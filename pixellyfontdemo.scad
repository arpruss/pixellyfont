include <pixellyfont.scad>;

//<params>
dots = false;
line1 = "Happy Birthday,";
line2 = "Name!";
size = 15;
letterHeight = 2;
backgroundHeight = 0.4;
equalizeWidth = false;
//</params>

_len1 = getStringWidth(line1,font=font_mactall,size=size);
_len2 = getStringWidth(line2,font=font_mactall,size=size);

len1 = equalizeWidth ? max(_len1,_len2) : _len1;
len2 = equalizeWidth ? max(_len1,_len2) : _len2;

translate([-len1/2-1,-1,0]) cube([len1+2,size+2,backgroundHeight]);
    translate([-len2/2-1,-size+1,0]) 
    cube([len2+1,size+2,backgroundHeight]);

if (!dots) {
    color("blue")
    renderString(line1,halign="center",valign="bottom",font=font_mactall,size=size,pixelScale=1.01,height=letterHeight);
    color("blue")
    translate([0,-size]) 
renderString(line2,halign="center",valign="bottom",font=font_mactall,pixelScale=1.01,size=size,height=letterHeight);
}
else {
    renderString(line1,halign="center",valign="bottom",font=font_mactall,size=size)
        color("blue") translate([0,0,letterHeight/2]) cylinder(d=.9*size/getFontHeight(font_mactall), h=letterHeight, $fn=12, center=true);
        translate([0,-size]) 
renderString(line2,halign="center",valign="bottom",font=font_mactall,size=size)
        color("blue") translate([0,0,letterHeight/2]) cylinder(d=.9*size/getFontHeight(font_mactall), h=letterHeight, $fn=12, center=true);
}
