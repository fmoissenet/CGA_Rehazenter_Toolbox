%{
Original concept by Matt Swartz: https://uk.mathworks.com/matlabcentral/fileexchange/10465-xlswrite1

This version by Nick Oatley 12-Dec-2018: based on R2018b source code for xlswrite with a couple of tweaks to fix things the editor suggested
  Source: C:\Program Files\MATLAB\R2018b\toolbox\matlab\iofun\xlswrite.m

Notes:
   1. Adds a local persistent reference to Excel (rather than Matt's way of having it in the caller)
   2. Doing a write to one filename followed by a write to a different filename results in the first file being closed and the second one opened.
   3. Excel is closed down after use by calling the function with no parameters.

   USAGE AS PER STANDARD "xlswrite" FUNCTION WITH ONE ADDITION:
      [status,message] = xlsWriteEx();                               closes the current file and instance of Excel
      [status,message] = xlsWriteEx(filename,A)                      other calls to xlsWriteEx as per standard xlswrite function
      [status,message] = xlsWriteEx(filename,A,sheet)
      [status,message] = xlsWriteEx(filename,A,xlRange)
      [status,message] = xlsWriteEx(filename,A,sheet,xlRange)

%}

function [success,theMessage] = xlsWriteEx(file,data,sheet,range)
%- Nick Oatley: beginning of additional code
   persistent Excel;
   persistent fName;

   if nargin == 0
   %- save and close the current workbook, quit Excel
      try
         Excel.ActiveWorkbook.Save; 
         Excel.ActiveWorkbook.Close(false);
      catch
      end
      try
         Excel.Quit;
         Excel = [];
      catch
      end
      fName = '';
      return;
   end
   
   if ~isempty(fName) && ~strcmpi(fName, file)
   %- different file to the current open one, so save and close it
      try
         Excel.ActiveWorkbook.Save; 
         Excel.ActiveWorkbook.Close(false);
      catch
      end
      fName = '';
   end
%- Nick Oatley: end of additional code
 
   % Set default values.
   Sheet1 = 1;

   if nargin < 3
       sheet = Sheet1;
       range = '';
   elseif nargin < 4
       range = '';
   end

   if nargout > 0
       success = true;
       theMessage = struct('theMessage',{''},'identifier',{''});
   end

   % Handle input.
   try
       % handle requested Excel workbook filename.
       if ~isempty(file)
           file = convertStringsToChars(file);
           if ~ischar(file)
               error(message('MATLAB:xlswrite:InputClassFilename'));
           end
           % check for wildcards in filename
           if any(strfind(file,'*'))
               error(message('MATLAB:xlswrite:FileName'));
           end
           [Directory,file,ext]=fileparts(file);
           if isempty(ext) % add default Excel extension;
               ext = '.xlsx';
           end
           file = abspath(fullfile(Directory,[file ext]));
           [a1, a2] = fileattrib(file);
           if a1 && ~(a2.UserWrite == 1)
               error(message('MATLAB:xlswrite:FileReadOnly'));
           end
           if ~isempty(fName) && ~strcmpi(file, fName)     % writing to a different file to the last write, so save and close any existing open file first
              try
                 Excel.ActiveWorkbook.Save;
                 Excel.ActiveWorkbook.Close(false);
              catch
              end
           end
       else % get workbook filename.
          error(message('MATLAB:xlswrite:EmptyFileName'));
       end

       % Check for empty input data
       if isempty(data)
           error(message('MATLAB:xlswrite:EmptyInput'));
       end
       data = convertStringsToChars(data);
       
       % Check for N-D array input data
       if ndims(data)>2
           error(message('MATLAB:xlswrite:InputDimension'));
       end

       % Check class of input data
       if ~(iscell(data) || isnumeric(data) || ischar(data) || isstring(data)) && ~islogical(data)
           error(message('MATLAB:xlswrite:InputClass'));
       end

       % convert input to cell array of data.
       if iscell(data)
           A=data;
       else   
           A=num2cell(data);
       end

       if nargin > 2
           % Verify class of sheet parameter.
           if ~(ischar(sheet) || (isnumeric(sheet) && sheet > 0))
               error(message('MATLAB:xlswrite:InputClassSheetArg'));
           end
           if isempty(sheet)
               sheet = Sheet1;
           end
           % parse REGION into sheet and range.
           % Parse sheet and range strings.
           if ischar(sheet) && contains(sheet,':')
               range = sheet; % only range was specified.
               sheet = Sheet1;% Use default sheet.
           elseif ~ischar(range)
               error(message('MATLAB:xlswrite:InputClassRangeArg'));
           end
       end

   catch exception
       narginchk(2,4);
       success = false;
       theMessage = exceptionHandler(nargout, exception);
       return;
   end
   
%------------------------------------------------------------------------------
   % Attempt to start Excel as ActiveX server.
   if isempty(Excel)                                                                   % << Nick Oatley: added
      try
          Excel = matlab.io.internal.getExcelInstance;
      catch
          warning(message('MATLAB:xlswrite:NoCOMServer'));
          if nargout > 0
              [theMessage.message,theMessage.identifier] = lastwarn;
          end
          % write data as CSV file, that is, comma delimited.
          file = regexprep(file,'(\.xls[^.]*+)$','.csv'); 
          try
              dlmwrite(file,data,','); % write data.
          catch exception
              exceptionNew = MException('MATLAB:xlswrite:dlmwrite','%s', getString(message('MATLAB:xlswrite:dlmwrite')));
              exceptionNew = exceptionNew.addCause(exception);
              if nargout == 0
                  % Throw error.
                  throw(exceptionNew);
              else
                  success = false;
                  theMessage.message = exceptionNew.getReport;
                  theMessage.identifier = exceptionNew.identifier;
              end
          end
          return;
      end
   end
   
   %------------------------------------------------------------------------------
   try
       % Construct range string
       if ~contains(range,':')
           % Range was partly specified or not at all. Calculate range.
           [m,n] = size(A);
           range = calcrange(range,m,n);
       end
   catch exception
       success = false;
       theMessage = exceptionHandler(nargout, exception);
       return;
   end

   %------------------------------------------------------------------------------
   try
      bCreated = ~exist(file,'file');
      if bCreated
         % Create new workbook.  
         % This is in place because in the presence of a Google Desktop Search installation, calling Add and
         % then SaveAs after adding data to create a new Excel file will leave an Excel process hanging.  
         % This workaround prevents it from happening by creating a blank file and saving it.  It can then be opened with Open.
         ExcelWorkbook = Excel.Workbooks.Add;
         switch ext
             case '.xls'      % xlExcel8 or xlWorkbookNormal
                xlFormat = -4143;
             case '.xlsb'     % xlExcel12
                xlFormat = 50;
             case '.xlsx'     % xlOpenXMLWorkbook
                xlFormat = 51;
             case '.xlsm'     % xlOpenXMLWorkbookMacroEnabled 
                xlFormat = 52;
             otherwise
                xlFormat = -4143;
         end
         ExcelWorkbook.SaveAs(file, xlFormat);
         ExcelWorkbook.Close(false);
         clear ExcelWorkbook;
      end

     %Open file
     if isempty(fName)                                                                          % << Nick Oatley: only open if it's not already open
%{
        readOnly = false;
        [~, ExcelWorkbook,workbookState] = openExcelWorkbook(Excel, file, readOnly);
        c = onCleanup(@()xlsCleanup(Excel,file,workbookState));
        
             Nick Oatley: the above two lines don't work unless we copy these files to our own folder:
                C:\Program Files\MATLAB\R2018b\toolbox\matlab\iofun\private\openExcelWorkbook.m
                C:\Program Files\MATLAB\R2018b\toolbox\matlab\iofun\private\xlsCleanup.m
             (see https://uk.mathworks.com/help/matlab/matlab_oop/organizing-classes-in-folders.html for reason why)
        
             So either we have to put xlsWriteEx.m into this folder:
                C:\Program Files\MATLAB\R2018b\toolbox\matlab\iofun\
             or we open Excel as below
%}
        Excel.Workbooks.Open(file);                                                             % << Nick Oatley: open Excel this way instead
        fName = file;                                                                           % << Nick Oatley: remember the current file
     end

%      if ExcelWorkbook.ReadOnly ~= 0
     if Excel.ActiveWorkbook.ReadOnly ~= 0                                                      % << Nick Oatley: ExcelWorkbook not persistent, so can't use it
         %This means the file is probably open in another process.
         error(message('MATLAB:xlswrite:LockedFile', file));
     end

     try
         % select region.
         % Activate indicated worksheet.
         [theMessage, TargetSheet, visibility] = activate_sheet(Excel,sheet);
     catch
        error(message('MATLAB:xlswrite:InvalidSheetName', sheet)); 
     end

     try
         % Select range in worksheet.
         Select(Range(Excel,sprintf('%s',range)));
     catch
         error(message('MATLAB:xlswrite:SelectDataRange'));
     end

     % Export data to selected region.
     set(Excel.Selection,'Value',A);

     resetVisibility(TargetSheet, visibility);
%         ExcelWorkbook.Save                                                                    % << Nick Oatley: removed as we only want to do one save when we close it

   catch exception
       if (bCreated && exist(file, 'file') == 2)
           delete(file);
       end
       success = false;
       theMessage = exceptionHandler(nargout, exception);
   end        
end

%--------------------------------------------------------------------------
function [theMessage, TargetSheet, visibility] = activate_sheet(Excel,Sheet)
% Activate specified worksheet in workbook.

   % Initialise worksheet object
   WorkSheets = Excel.Sheets;
   theMessage = struct('theMessage',{''},'identifier',{''});

   % Get name of specified worksheet from workbook
   try
       TargetSheet = get(WorkSheets,'item',Sheet);
   catch
       % Worksheet does not exist. Add worksheet.
       TargetSheet = addsheet(WorkSheets,Sheet);
       warning(message('MATLAB:xlswrite:AddSheet'));
       if nargout > 0
           [theMessage.theMessage,theMessage.identifier] = lastwarn;
       end
   end

   % We temporarily make xlSheetHidden and xlSheetVeryHidden spreadsheets
   % xlsheetVisible so we can write to them. Store the visibility for later.
   visibility = get(TargetSheet, 'Visible');

   % Activate silently fails if the sheet is hidden
   set(TargetSheet, 'Visible', 'xlSheetVisible');

   % activate worksheet
   Activate(TargetSheet);
end

%--------------------------------------------------------------------------
function resetVisibility(TargetSheet, visibility)
% Rehide the sheet after writing if it was hidden at the start
   if ismember(visibility, {'xlSheetHidden', 'xlSheetVeryHidden'})  
       set(TargetSheet, 'Visible', visibility);
   end
end

%------------------------------------------------------------------------------
function newsheet = addsheet(WorkSheets, Sheet)
% Add new worksheet, Sheet into worksheet collection, WorkSheets.
   if isnumeric(Sheet)
       % iteratively add worksheet by index until number of sheets == Sheet.
       while WorkSheets.Count < Sheet
           % find last sheet in worksheet collection
           lastsheet = WorkSheets.Item(WorkSheets.Count);
           newsheet = WorkSheets.Add([],lastsheet);
       end
   else
       % add worksheet by name.
       % find last sheet in worksheet collection
       lastsheet = WorkSheets.Item(WorkSheets.Count);
       newsheet = WorkSheets.Add([],lastsheet);
   end
   % If Sheet is a string, rename new sheet to this string.
   if ischar(Sheet)
       set(newsheet,'Name',Sheet);
   end
end

%------------------------------------------------------------------------------
function [absolutepath]=abspath(partialpath)
% parse partial path into path parts
   [pathname, filename, ext] = fileparts(partialpath);
   % no path qualification is present in partial path; assume parent is pwd, except when path string starts with '~' or is identical to '~'.
   if isempty(pathname) && partialpath(1) ~= '~'
       Directory = pwd;
   elseif isempty(regexp(partialpath,'^(.:|\\\\|/|~)','once'))
       % path did not start with any of drive name, UNC path or '~'.
       Directory = [pwd,filesep,pathname];
   else
       % path content present in partial path; assume relative to current directory, or absolute.
       Directory = pathname;
   end

   % construct absolute filename
   absolutepath = fullfile(Directory,[filename, ext]);
end

%------------------------------------------------------------------------------
function range = calcrange(range,m,n)
% Calculate full target range, in Excel A1 notation, to include array of size
% m x n
   import matlab.io.spreadsheet.internal.columnLetter;
   import matlab.io.spreadsheet.internal.columnNumber;

   range = upper(range);
   cols = isletter(range);
   rows = ~cols;
   % Construct first row.
   if ~any(rows)
       firstrow = 1; % Default row.
   else
       firstrow = str2double(range(rows)); % from range input.
   end
   % Construct first column.
   if ~any(cols)
       firstcol = 'A'; % Default column.
   else
       firstcol = range(cols); % from range input.
   end
   try
       lastrow = num2str(firstrow+m-1);   % Construct last row as a string.
       firstrow = num2str(firstrow);      % Convert first row to string image.
       lastcol = columnLetter(columnNumber(firstcol)+n-1); % Construct last column.

       range = [firstcol firstrow ':' lastcol lastrow]; % Final range string.
   catch
       error(message('MATLAB:xlswrite:CalculateRange', range));
   end
end

%-------------------------------------------------------------------------------
function messageStruct = exceptionHandler(nArgs, exception)
    if nArgs == 0
        throwAsCaller(exception);  	   
    else
        messageStruct.message = exception.message;       
        messageStruct.identifier = exception.identifier;
    end
end
