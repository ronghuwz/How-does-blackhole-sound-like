function image_to_sound_RongHu(imagePath, f_low, f_high, duration)
    % Read and process the image
    img = imread(imagePath);
    % Convert to grayscale if not already (if needed)
    if size(img, 3) == 3
        img = rgb2gray(img);
    end
    
    [rows, cols] = size(img); % Get dimensions of the image
    
    % Sound parameters
    f_sample = 44100; % Sampling frequency
    deltaT = duration / cols; % Time duration for each column's sound

    % Generate sound for each column
    final_sound = [];
    tstart = 0;
    for i = 1:cols-1
        % Initialize sound for this column
        column_sound = zeros(1, round(f_sample * deltaT)); 

        for j = 1:rows
            % Get pixel intensity and map it to amplitude and frequency
            pixel_intensity = double(img(j,i));
            amp = pixel_intensity / 255; % Normalize to [0, 1]

            % Map intensity to frequency range
            freq = f_low + (f_high - f_low) * amp;  
            
            % Generate sound for this pixel
            t = linspace(tstart, tstart + deltaT, round(f_sample * deltaT));
            pixel_sound = sin(2 * pi * freq * t) * amp;
            
            % Add this pixel's sound to the column sound
            column_sound = column_sound + pixel_sound;
        end
        tstart = tstart + deltaT;
        
        % Add the column's sound to the final sound
        final_sound = cat(2, final_sound, column_sound);
    end
    
    total_samples = length(final_sound);
    total_duration = total_samples / f_sample;
    fprintf('Total duration of the generated sound: %.3f seconds\n', total_duration);

    % Play the final sound
    soundsc(final_sound, f_sample);

    % Plotting waveform
    figure;
    plot(final_sound);
    title('Waveform of the Generated Sound');
    xlabel('Sample Number');
    ylabel('Amplitude');
end

image_to_sound_RongHu('blackhole.jpg', 100, 2000, 10);
