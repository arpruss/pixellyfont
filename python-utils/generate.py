from fonts import *

out = ""
for name in FONTS:
    out += "font_" + name + "=[";
    font = FONTS[name]
    glyphs = []
    for i in range(32,256):
        if i not in font:
            width,offset,delta,bitmap = font[32]
        else:
            width,offset,delta,bitmap = font[i]
        
        glyph = "[%d,%d,%d,[" % (width,offset,delta)
        glyph += ",".join(str(d) for d in bitmap)
        glyph += "]]"
        glyphs.append(glyph)    
    out += ','.join(glyphs) + "];\n"

print out