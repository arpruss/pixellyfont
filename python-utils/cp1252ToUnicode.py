data = 'cp1252 = "'

for i in range(32,256):
    try:
        if chr(i) in ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_':
            data += chr(i)
        else:
            data += '\\u%04x' % ord(chr(i).decode("cp1252"));
    except:
        data += ' '
        
data += '";'

print data