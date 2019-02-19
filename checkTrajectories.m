cd('C:\Users\florent.moissenet\Documents\Professionnel\data\A multimodal dataset of human gait at different walking speeds');
folder = uigetdir;
cd(folder);
files = dir('*.c3d');
for i = 1:size(files,1)
    figure;
    btk = btkReadAcquisition(files(i).name);
    Marker = btkGetMarkers(btk);
    nMarker = fieldnames(Marker);
    for j = 1:size(nMarker,1)
        subplot(1,3,1); hold on; box on; grid on;
        plot(Marker.(nMarker{j})(:,1));
        subplot(1,3,2); hold on; box on; grid on;
        plot(Marker.(nMarker{j})(:,2));
        subplot(1,3,3); hold on; box on; grid on;
        plot(Marker.(nMarker{j})(:,3));
    end
end