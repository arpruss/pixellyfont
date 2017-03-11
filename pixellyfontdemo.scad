include <pixellyfont.scad>;

line1 = "Happy Birthday,";
line2 = "Name!";
size = 15;
letterHeight = 1.5;
backgroundHeight = 0.4;

len1 = getStringWidth(line1,font=font_mactall,size=size);
translate([-len1/2-0.5,0,0]) cube([len1+1,size+1,backgroundHeight]);
renderString(line1,halign="center",font=font_mactall,size=size,positiveScale=1.01,negativeScale=0,positiveExtrude=1.5);
len2 = getStringWidth(line2,font=font_mactall,size=size);
translate([0,-size]) {
    translate([-len2/2-0.5,0,0]) cube([len2+1,size+1,backgroundHeight]);
    renderString(line2,halign="center",font=font_mactall,positiveScale=1,size=size,positiveScale=1.01,negativeScale=0,positiveExtrude=1.5,negativeExtrude=0.4);
}