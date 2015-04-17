mkdir appiconset

convert $1 -resize 29x29 appiconset/iphone_ios_5_6_spotlight_and_settings_ios5_8@1x.png
convert $1 -resize 58x58 appiconset/iphone_ios_5_6_spotlight_and_settings_ios5_8@2x.png
convert $1 -resize 87x87 appiconset/iphone_ios_5_6_spotlight_and_settings_ios5_8@3x.png

convert $1 -resize 80x80 appiconset/iphone_ios_7_8_spotlight@2x.png
convert $1 -resize 120x120 appiconset/iphone_ios_7_8_spotlight@3x.png

convert $1 -resize 57x57 appiconset/iphone_ios_5_6@1x.png
convert $1 -resize 114x114 appiconset/iphone_ios_5_6@2x.png

convert $1 -resize 120x120 appiconset/iphone_ios_7_8@2x.png
convert $1 -resize 180x180 appiconset/iphone_ios_7_8@3x.png

convert $1 -resize 29x29 appiconset/ipad_ios_5_8_settings@1x.png
convert $1 -resize 58x58 appiconset/ipad_ios_5_8_settings@2x.png

convert $1 -resize 40x40 appiconset/ipad_ios_7_8_spotlight@1x.png
convert $1 -resize 80x80 appiconset/ipad_ios_7_8_spotlight@2x.png

convert $1 -resize 50x50 appiconset/ipad_spotlight_ios_5_6@1x.png
convert $1 -resize 100x100 appiconset/ipad_spotlight_ios_5_6@2x.png

convert $1 -resize 72x72 appiconset/ipad_ios_5_6@1x.png
convert $1 -resize 144x144 appiconset/ipad_ios_5_6@2x.png

convert $1 -resize 76x76 appiconset/ipad_ios_7_8@1x.png
convert $1 -resize 152x152 appiconset/ipad_ios_7_8@2x.png

