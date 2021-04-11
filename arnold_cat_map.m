%Arnold cat map
function photo = arnold_cat_map(photo)
    [y, x, ~] = size(photo);
    oldScrambledImage = photo;
    N = y;
    i = 0;
    while i < 7
        for row = 1 : y
            for col = 1 : x
                x1 = mod((2 * col) + row, N) + 1; %x
                y1 = mod(col + row, N) + 1; %y
                currentScrambledImage(row, col, :) = oldScrambledImage(y1, x1, :);
           end
        end
        oldScrambledImage = currentScrambledImage;
        i = i+1;
    end
    photo = currentScrambledImage;