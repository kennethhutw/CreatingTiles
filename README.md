# CreatingTiles 創建圖磚

There are a number of ways to create tiles from large images - some online services exist, but tend to be limited in file size and not as flexible as desktop applications.
有多種方式來創建從放大圖瓷磚 - 存在一些在線服務，但因為桌面應用程序所以往往在文件大小是有限的，不靈活。

While it's possible to do in PhotoShop, using the slice tool, you're limited to a total number of tiles (I forget the limit, but I do remember it usually wasn't enough). 
雖然我們可以用Photoshop做，使用切片工具，你僅限於瓷磚的總數（我忘記了極限，但我記得它通常是不夠的）。

You could use multiple slice operations, but IMO the free utility ImageMagick is the best bet. 
您可以使用多個切片操作，但免費的實用工具ImageMagick應該是最好的選擇。

Just download the binary somewhere and use the command line (windows, mac, or nix) to run it.
只要下載二進制的地方，並使用命令行（在Windows，Mac ，或者nix）來運行它。

The main command you'll want to run is something like this:
主要命令是這樣的：


` c:\path\to\imagemagick\convert c:\path\to\big\image.png -crop 256x256 -set filename:tile "%%[fx:page.x/256]_%%[fx:page.y/256]" +repage +adjoin c:\path\to\tile\folder\tile-%%[filename:tile].png"` .

The above will split image.png into 256x256 tiles, and name them "tile-i-j.png", where "i" is the column index and "j" is the row index.
會切割成image.png 256×256圖磚，並將它們命名為“tile-i-j.png”，其中“i”是列索引和“J”是行索引。

If you have a really large image, you may run out of memory - if that's the case, then you'll need to cache the image during the process, by adding these switches:
如果你有一個非常大的圖片，你可以用盡內存 - 如果是這樣的話，那麼你就需要在此過程中緩存的圖片，加入這些開關：

` -limit map 0 -limit memory 0` .

e.g.,

` c:\path\to\imagemagick\convert -limit map 0 -limit memory 0 c:\path\to\big\image.png -crop 256x256 -set filename:tile "%%[fx:page.x/256]_%%[fx:page.y/256]" +repage +adjoin c:\path\to\tile\folder\tile-%%[filename:tile].png"` .


Based on work by Tristus1er, here's a batch script that'll create 4 tile sets and samples from a single image (note that this might not be appropriate for all apps - most of the apps I've done have used different images for some of the different tile sets).
這裡有一個批處理腳本會從一個單一圖片創建4套圖片和範例（注意，這可能不適用於所有的應用程序是適當的 - 最讓我做了使用了不同的圖像對於一些應用程序不同的圖磚） 。
You'll need to set the first 8 variables to the appropriate values.
你需要前8個變量設定為合適的值。

`
@echo off

echo should already have original image in folder, as well as folders named tiles and samples

set basename=my_image_base_name
set filename=my-image.jpg
set extension=jpg

set imagemagick=C:\path\to\ImageMagick\convert
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
 ` 
 
If you don't know how to do, you can download my files from sample folder. 
I use batch file to splite Singapore map into 4 set  tiles 
如果你不知道該怎麼做，你可以從Sample folder下載範例執行。
我使用批處理文件來splite新加坡地圖分成4組瓦片
 
 PS : I use ImageMagick-6.9.3-Q16 version. 
 