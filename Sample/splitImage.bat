@echo off

echo should already have original image in folder, as well as folders named tiles and samples

set basename=Singapore
set filename=Singapore-google.png
set extension=png

set imagemagick=C:\Programs\ImageMagick-6.9.3-Q16\convert
set /a tilesize=256
set /a samplesize=500

set tilesfolder=tiles
set samplesfolder=samples

echo create tile folders
mkdir %tilesfolder%\%basename%
mkdir %tilesfolder%\%basename%\1000
mkdir %tilesfolder%\%basename%\500
mkdir %tilesfolder%\%basename%\250
mkdir %tilesfolder%\%basename%\125

echo create half-sized versions for tiling (will be discarded later)
%imagemagick% %filename% -resize 50%%  %basename%-500.%extension%
%imagemagick% %filename% -resize 25%%  %basename%-250.%extension%
%imagemagick% %filename% -resize 12.5%%  %basename%-125.%extension%

echo create sample
%imagemagick% %filename% -thumbnail %samplesize%x%samplesize%  ./%samplesfolder%/%filename%

echo create tiles
%imagemagick% %filename% -crop %tilesize%x%tilesize% -set filename:tile "%%[fx:page.x/%tilesize%]_%%[fx:page.y/%tilesize%]" +repage +adjoin "./%tilesfolder%/%basename%/1000/%%[filename:tile].%extension%"
%imagemagick% %basename%-500.%extension% -crop %tilesize%x%tilesize% -set filename:tile "%%[fx:page.x/%tilesize%]_%%[fx:page.y/%tilesize%]" +repage +adjoin "./%tilesfolder%/%basename%/500/%%[filename:tile].%extension%"
%imagemagick% %basename%-250.%extension% -crop %tilesize%x%tilesize% -set filename:tile "%%[fx:page.x/%tilesize%]_%%[fx:page.y/%tilesize%]" +repage +adjoin "./%tilesfolder%/%basename%/250/%%[filename:tile].%extension%"
%imagemagick% %basename%-125.%extension% -crop %tilesize%x%tilesize% -set filename:tile "%%[fx:page.x/%tilesize%]_%%[fx:page.y/%tilesize%]" +repage +adjoin "./%tilesfolder%/%basename%/125/%%[filename:tile].%extension%"

echo cleanup
del %basename%-500.%extension%
del %basename%-250.%extension%
del %basename%-125.%extension%

echo DONE
pause