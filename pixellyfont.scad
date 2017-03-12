include <fontdata.scad>;

function cp1252Decode(c) = let(found = search(c, cp1252)) len(found) > 0 ? found[0]+32 : 32;

function toGlyphArray(font,s) = [for (i=[0:len(s)-1]) font[cp1252Decode(s[i])-32]];
    
function sumTo(array,n) = n <= 0 ? 0 : array[n-1] + sumTo(array,n-1);

function sum(array) = sumTo(array,len(array));

function getBit(x, n) = floor(x / pow(2,n)) % 2 == 1;

function getFontHeight(font) = len(font[0][3]);

module renderGlyph(width, bitmap, size=10) {
    height = len(bitmap);
    pixel = size/height;
    for (y=[0:height-1]) for(x=[0:width-1]) {
        bit = getBit(bitmap[height-1-y],width-1-x);
        translate([pixel*(x+0.5),pixel*(y+0.5)]) {
            if (bit) 
                children(0);
            else if ($children>1) {
                children(1);
            }
        }
    }
}   

function getGlyphArrayWidth(glyphArray,spacing=1,size=10) = let(pixelSize = size / len(glyphArray[0][3]), n=len(glyphArray),
    sizes = [for (i=[0:n-1]) (glyphArray[i][1]+glyphArray[i][2])*pixelSize*spacing]) sum([for (i=[0:n-1]) (glyphArray[i][1]+glyphArray[i][2])*pixelSize*spacing]);

function getStringWidth(string,font=font_8x8,spacing=1,size=10) = getGlyphArrayWidth(toGlyphArray(font,string),spacing=spacing,size=size);
    
module renderGlyphArray(glyphArray,halign="left",valign="bottom",spacing=1,size=10) {
    n = len(glyphArray);
    pixelSize = size / len(glyphArray[0][3]);
    sizes = [for (i=[0:n-1]) (glyphArray[i][1]+glyphArray[i][2])*pixelSize*spacing];
    leftOffset = halign == "left" ? 0 : (halign == "right" ? -sum(sizes) : -sum(sizes)/2);
    numRows = len(glyphArray[0][0][3]);
    bottomOffset = valign == "top" ? -size : (valign == "center" ? -size/2 : 0);
    for (i=[0:n-1]) translate([leftOffset + sumTo(sizes,i) + spacing*glyphArray[i][1], bottomOffset]) 
        renderGlyph(glyphArray[i][0], glyphArray[i][3], size=size) {
            children(0); 
            if ($children>1) children(1); 
        }
}

module renderString(string,font=font_8x8,halign="left",valign="bottom",spacing=1,size=10,positiveScale=1.01,negativeScale=0,positiveColor="blue",negativeColor="white",positiveExtrude=0,negativeExtrude=0,customPixels=false) {
    glyphArray = toGlyphArray(font,string);
    pixel = size / getFontHeight(font);
    positivePixel = positiveScale * pixel;
    negativePixel = negativeScale * pixel;
    
    if (customPixels) 
        renderGlyphArray(glyphArray,halign=halign,valign=valign,spacing=spacing,size=size) {
            children(0); 
            if($children>1) children(1);
        }
    else {
        renderGlyphArray(glyphArray,halign=halign,valign=valign,spacing=spacing,size=size) {
            color(positiveColor) if(positiveExtrude>0) translate([positivePixel/2,positivePixel/2,0]) cube([positivePixel,positivePixel,positiveExtrude]); else square([positivePixel,positivePixel],center=true);
            color(negativeColor) if(negativeExtrude>0) translate([negativePixel/2,negativePixel/2,0]) cube([negativePixel,negativePixel,negativeExtrude]); else square([negativePixel,negativePixel],center=true);
        } 
    }
}

/*
pixel = 10/getFontHeight(font_8x8);
render(convexity=2)
renderString("abc",customPixels=true) {
    circle(d=1*pixel, $fn=10);
    difference() {
        circle(d=1*pixel, $fn=10);
        circle(d=0.8*pixel, $fn=10);
    }
}
*/