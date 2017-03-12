include <pixellyfont.scad>;

dots = true;
line1 = "Happy Birthday,";
line2 = "Name!";
size = 15;
letterHeight = 2;
backgroundHeight = 0.4;

len1 = getStringWidth(line1,font=font_mactall,size=size);
len2 = getStringWidth(line2,font=font_mactall,size=size);

translate([-len1/2-1,-1,0]) cube([len1+2,size+2,backgroundHeight]);
    translate([-len2/2-1,-size+1,0]) 
    cube([len2+1,size+2,backgroundHeight]);

if (!dots) {
    renderString(line1,halign="center",valign="bottom",font=font_mactall,size=size,positiveScale=1.01,negativeScale=0,positiveExtrude=letterHeight,negativeExtrude=1);
    translate([0,-size]) 
renderString(line2,halign="center",valign="bottom",font=font_mactall,positiveScale=1,size=size,positiveScale=1.01,negativeScale=0,positiveExtrude=letterHeight,negativeExtrude=1);
}
else {
    renderString(line1,halign="center",valign="bottom",font=font_mactall,size=size,customPixels=true)
        color("blue") translate([0,0,letterHeight/2]) cylinder(d=.9*size/getFontHeight(font_mactall), h=letterHeight, $fn=12, center=true);
        translate([0,-size]) 
renderString(line2,halign="center",valign="bottom",font=font_mactall,positiveScale=1,size=size,customPixels=true)
        color("blue") translate([0,0,letterHeight/2]) cylinder(d=.9*size/getFontHeight(font_mactall), h=letterHeight, $fn=12, center=true);
}
