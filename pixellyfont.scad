include <fontdata.scad>;

function _asc(c,m) = m <= 0 ? 32 : (chr(m)==c ? m : _asc(c,m-1));
function asc(n) = _asc(n,256);

function toGlyphArray(font,s) = [for (i=[0:len(s)-1]) font[asc(s[i])-32]];
    
function sumTo(array,n) = n <= 0 ? 0 : array[n-1] + sumTo(array,n-1);

function sum(array) = sumTo(array,len(array));

function getBit(x, n) = floor(x / pow(2,n)) % 2 == 1;

module renderGlyph(width, bitmap, size=10, positiveScale=1, negativeScale=0, positiveColor="blue", negativeColor="white",positiveExtrude=0,negativeExtrude=0) {
    height = len(bitmap);
    pixel = size/height;
    for (y=[0:height-1]) for(x=[0:width-1]) {
        bit = getBit(bitmap[height-1-y],width-1-x);
        size = bit ? positiveScale * pixel : negativeScale * pixel;
        extrude = bit ? positiveExtrude : negativeExtrude;
        translate([pixel*(x+0.5),pixel*(y+0.5)]) color(bit ? positiveColor : negativeColor) if(extrude>0) translate([0,0,extrude/2]) cube([size,size,extrude], center=true);
            else
        square(center=true, size=size);
    }
}   

function getGlyphArrayWidth(glyphArray,spacing=1,size=10) = let(pixelSize = size / len(glyphArray[0][3]), n=len(glyphArray),
    sizes = [for (i=[0:n-1]) (glyphArray[i][1]+glyphArray[i][2])*pixelSize*spacing]) sum([for (i=[0:n-1]) (glyphArray[i][1]+glyphArray[i][2])*pixelSize*spacing]);

function getStringWidth(string,font=font_8x8,spacing=1,size=10) = getGlyphArrayWidth(toGlyphArray(font,string),spacing=spacing,size=size);
    
module renderGlyphArray(glyphArray,halign="left",valign="bottom",spacing=1,size=10,positiveScale=1,negativeScale=0,positiveColor="blue",negativeColor="white",positiveExtrude=0,negativeExtrude=0) {
    n = len(glyphArray);
    pixelSize = size / len(glyphArray[0][3]);
    sizes = [for (i=[0:n-1]) (glyphArray[i][1]+glyphArray[i][2])*pixelSize*spacing];
    leftOffset = halign == "left" ? 0 : (halign == "right" ? -sum(sizes) : -sum(sizes)/2);
    numRows = len(glyphArray[0][0][3]);
    bottomOffset = valign == "top" ? -size : (valign == "center" ? -size/2 : 0);
    for (i=[0:n-1]) translate([leftOffset + sumTo(sizes,i) + spacing*glyphArray[i][1], bottomOffset]) renderGlyph(glyphArray[i][0], glyphArray[i][3], size=size,positiveScale=positiveScale,negativeScale=negativeScale,positiveColor=positiveColor,negativeColor=negativeColor,positiveExtrude=positiveExtrude,negativeExtrude=negativeExtrude);
}

module renderString(string,font=font_8x8,halign="left",spacing=1,size=10,positiveScale=1,negativeScale=0,positiveColor="blue",negativeColor="white",positiveExtrude=0,negativeExtrude=0) {
    glyphArray = toGlyphArray(font,string);
    renderGlyphArray(glyphArray,halign=halign,spacing=spacing,size=size,positiveScale=positiveScale,negativeScale=negativeScale,positiveColor=positiveColor,negativeColor=negativeColor,positiveExtrude=positiveExtrude,negativeExtrude=negativeExtrude);
}
