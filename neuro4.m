function NeuroPlaylist
    % --- Song Database: {Name, [Tempo, Mode, Energy]}
    songs = {
         'Sleep on the Floor', [135 1 0.70];
        'To Build a Home', [122 0 0.25];
        'Chasing Cars', [112 0 0.45];
        'Iris', [150 1 0.65];
        'Heartbeats', [96 0 0.40];
        'Would That I', [118 0 0.55];
        'Mess is Mine', [124 1 0.70];
        'Sally When the Wine Runs Out', [105 1 0.55];
        'Rollercoaster', [156 1 0.85];
        'Dancing Queen', [100 1 0.85];
        'Radio GaGa', [115 1 0.75];
        'Eleanor Rigby', [138 0 0.60];
        'My Tears Ricochet', [116 0 0.40];
        'You Found Me', [129 0 0.65];
        'Fire and the Flood', [121 0 0.70];
        'Cleopatra', [123 0 0.60];
        'Ophelia', [130 1 0.65];
        'The Scientist', [146 0 0.50];
        'Oceans', [117 0 0.45];
        'Space Song', [110 0 0.50];
        'Myth', [120 0 0.55];
        'Coastline', [128 1 0.65];
        'Somewhere Only We Know', [145 0 0.60];
        'The Night We Met', [114 0 0.45];
        'Next to You', [102 1 0.55];
        'Province', [134 0 0.65];
        'Dark Red', [108 0 0.60];
        'Can I Call You Tonight', [121 1 0.70];
        'Brazil', [123 1 0.65];
        'Almost (Sweet Music)', [140 1 0.75];
        'Cherry Wine', [106 1 0.45];
        'The Sound', [120 1 0.85];
        'Misses', [118 1 0.65];
        'Pure', [115 1 0.55];
        'So High School', [122 1 0.75];
        'Back to Friends', [111 1 0.55];
        'Blue Hair', [108 0 0.55];
        'Youth', [126 1 0.70];
        'Apocalypse', [112 0 0.45];
        'I Like Me Better', [122 1 0.75];
        'Someone to Stay', [116 0 0.40];
        'Truly', [108 0 0.40];
        'Sweet', [110 0 0.35];
        'Radio', [117 0 0.50];
        'She Will Be Loved', [116 1 0.65];
        'Softcore', [120 0 0.55];
        'Real Love Baby', [118 1 0.60];
        'I Wanna Be Yours', [104 0 0.50];
        'Clocks', [131 1 0.80];
        'Photograph', [108 1 0.50];
        'A Thousand Years', [138 1 0.45];
        'This Town', [106 1 0.50];
        'Look After You', [120 0 0.55];
        'Love Like Ghosts', [124 0 0.60];
        'Mr. Loverman', [117 0 0.55];
        'Somebody Else', [134 0 0.55];
        'My Love Mine All Mine', [101 0 0.40];
        'Motion Sickness', [135 1 0.65];
        'Scott Street', [115 0 0.45];
        'She Calls Me Back', [124 1 0.65];
        'Stick Season', [120 1 0.65];
        'Orange Juice', [116 0 0.55];
        'I Love You I''m Sorry', [110 0 0.45];
        'Deja Vu', [115 0 0.70];
        'Pink Skies', [117 1 0.70];
        'Dark Matter', [108 0 0.50];
        'Foolmuse', [112 0 0.55];
        'C U Girl', [106 0 0.50];
        'Glue Myself Shut', [115 0 0.55];
        'Heavy', [118 0 0.55];
        'Undressed', [114 1 0.55];
        'The Less I Know the Better', [118 1 0.80];
        'Selfless', [124 0 0.60];
        'On the Floor', [111 0 0.50];
        '12 to 12', [109 1 0.60];
        'Sanctuary', [123 1 0.65];
        'Your Man', [118 0 0.60];
        'Sober', [120 1 0.75];
        'Thinking About You', [128 0 0.55];
        'Lost', [124 1 0.70];
        'Ivy', [112 0 0.55];
        'White Ferrari', [107 0 0.45];
        'Slow Dancing in the Dark', [116 0 0.50];
        'The Spins', [148 1 0.85];
        'Feels Like We Only Go Backwards', [123 1 0.70];
        'Eventually', [120 0 0.65];
        'In My Room', [126 0 0.65];
    };

    % --- Extract features for clustering (tempo, mode, energy)
    allFeatures = cell2mat(songs(:,2));
    allFeatures(:,1) = (allFeatures(:,1) - 60) / (200-60);
    allFeatures(:,1) = max(0, min(allFeatures(:,1),1));

    VA = zeros(size(allFeatures,1),2);
    for i=1:size(allFeatures,1)
        tmp = mapFeaturesToEmotion([songs{i,2}(1) songs{i,2}(2) songs{i,2}(3)]);
        VA(i,:) = [tmp.valence, tmp.arousal];
    end

    k = 6;
    [~, rfCenters] = kmeans(VA, k, 'Replicates', 5);

    % --- Create UI Window (smaller size)
    fig = uifigure('Name','Neuro Playlist Builder','Position',[100 100 1200 600]);
    fig.Color = [0.95 0.97 1]; 

    % --- Input controls
    uilabel(fig,'Position',[30 560 150 30],'Text','Enter Song Name:');
    songInput = uieditfield(fig,'text','Position',[160 565 200 25]);

    uibutton(fig,'push','Text','Generate Playlist',...
        'Position',[380 565 120 25],...
        'ButtonPushedFcn',@(btn,event) generatePlaylist());

    % --- Output: Listbox
    outputBox = uilistbox(fig,'Position',[30 200 300 340],'FontSize',12);

    % --- Emotion Label
    emotionLabelUI = uilabel(fig, ...
        'Position',[30 170 300 20], ...
        'Text','Emotion: (none yet)', ...
        'FontSize',14, 'FontWeight','bold');

    % --- Axes: Emotion Map
    axEmotion = uiaxes(fig,'Position',[360 320 300 250]);
    xlabel(axEmotion,'Valence'); ylabel(axEmotion,'Arousal');
    title(axEmotion,'Emotion Map'); xlim(axEmotion,[0 1]); ylim(axEmotion,[0 1]); grid(axEmotion,'on');

    % --- Axes: Receptive Field Map
    axRF = uiaxes(fig,'Position',[700 320 300 250]);
    xlabel(axRF,'Valence'); ylabel(axRF,'Energy');
    title(axRF,'Receptive Field Map');
    xlim(axRF,[0 1]); ylim(axRF,[0 1]); hold(axRF,'on');

    % --- Axes: Neural Firing Bar Chart
    axBar = uiaxes(fig,'Position',[360 50 300 220]);
    title(axBar,'Neural Firing Activity');
    xlabel(axBar,'Neuron Index'); ylabel(axBar,'Firing Strength (Hz)');
    ylim(axBar,[0 1]);

    % --- Axes: Raster Plot (fits bottom-right)
    axRaster = uiaxes(fig,'Position',[700 50 300 220]);
    title(axRaster,'Raster Plot');
    xlabel(axRaster,'Time (s)'); ylabel(axRaster,'Neuron');

    % ---- Callback ----
    function generatePlaylist()
        userSong = songInput.Value;
        idx = find(strcmpi(userSong, songs(:,1)), 1);
        if isempty(idx)
            outputBox.Items = {'Song not found in database.'};
            return;
        end
        inputFeatures = songs{idx,2};

        % Similarity calculation
        similarities = zeros(size(songs,1),1);
        for i = 1:size(songs,1)
            if i ~= idx
                similarities(i) = dot(inputFeatures,songs{i,2}) / ...
                    (norm(inputFeatures)*norm(songs{i,2}));
            else
                similarities(i) = -Inf;
            end
        end
        [~,sortedIdx] = sort(similarities,'descend');
        recommended = songs(sortedIdx(1:3),:);

        % Display text output
        outputBox.Items = [
            {['Input Song: ' userSong ' → Recommendations:']};
            recommended(:,1)
        ];

        % Emotion coords
        outMain = mapFeaturesToEmotion(inputFeatures);
        outRecs = cellfun(@(x) mapFeaturesToEmotion(x), recommended(:,2), 'UniformOutput', false);

        % --- Emotion map ---
        cla(axEmotion); hold(axEmotion,'on');
        scatter(axEmotion,outMain.valence, outMain.arousal, 120,'r','filled');
        text(axEmotion,outMain.valence+0.02,outMain.arousal,['Selected (' outMain.emotionLabel ')'],'Color','r');
        for i=1:3
            scatter(axEmotion,outRecs{i}.valence, outRecs{i}.arousal,80,'b','filled');
            text(axEmotion,outRecs{i}.valence+0.02,outRecs{i}.arousal,['Rec' num2str(i)],'Color','b');
        end
        hold(axEmotion,'off');

        % --- Receptive Field Map
        cla(axRF); hold(axRF,'on');
        [X,Y] = meshgrid(linspace(0,1,50),linspace(0,1,50));
        for i=1:size(rfCenters,1)
            sigma = 0.15;
            Z = exp(-((X-rfCenters(i,1)).^2 + (Y-rfCenters(i,2)).^2)/(2*sigma^2));
            contourf(axRF,X,Y,Z,[0.3 0.3],'LineColor','none','FaceAlpha',0.1);
        end
        energyIn = inputFeatures(3);
        scatter(axRF,outMain.valence,energyIn,100,'r','filled');
        for i=1:3
            scatter(axRF,outRecs{i}.valence,recommended{i,2}(3),100,'g','p','filled');
        end
        hold(axRF,'off');

        % --- Neural firing bar chart ---
        cla(axBar);
        neuronCenters = rfCenters;
        songPoint = [outMain.valence energyIn];
        firing = exp(-sum((neuronCenters - songPoint).^2,2)/(2*0.1^2));
        bar(axBar,1:k,firing,'FaceColor',[0.2 0.6 1]);
        ylim(axBar,[0 1]);
        title(axBar,['Neural Firing Activity (' outMain.emotionLabel ')']);

        % --- Raster plot ---
        cla(axRaster); hold(axRaster,'on');
        T = 1; dt = 0.01; time = 0:dt:T;
        for n=1:k
            rate = firing(n)*20; % Hz scaled
            spikes = rand(size(time)) < rate*dt;
            spikeTimes = time(spikes);
            for s=1:length(spikeTimes)
                line(axRaster,[spikeTimes(s) spikeTimes(s)], [n-0.4 n+0.4], 'Color','k');
            end
        end
        ylim(axRaster,[0 k+1]);
        xlim(axRaster,[0 T]);
        hold(axRaster,'off');

        % --- Update emotion label
        emotionLabelUI.Text = ['Emotion: ' outMain.emotionLabel];
    end
end

% ---------- Helper: map features to emotion ----------
function out = mapFeaturesToEmotion(features)
    tempo  = double(features(1));
    mode   = double(features(2));
    energy = double(features(3));

    tempo = max(30, min(tempo, 220));
    mode  = double(mode ~= 0);
    energy = max(0, min(energy,1));
    tempoNorm = max(0, min((tempo - 60) / (200 - 60),1));

    arousal = 0.6 * energy + 0.4 * tempoNorm;
    valence = 0.6 * mode + 0.3 * energy + 0.1 * tempoNorm;

    if arousal >= 0.6 && valence >= 0.6
        emotionLabel = 'Excited / Joyful';
    elseif arousal >= 0.6 && valence < 0.6
        emotionLabel = 'Anxious / Agitated';
    elseif arousal < 0.6 && valence >= 0.6
        emotionLabel = 'Calm / Content';
    else
        emotionLabel = 'Sad / Melancholic';
    end

    out = struct('arousal',arousal,'valence',valence,'emotionLabel',emotionLabel);
end
