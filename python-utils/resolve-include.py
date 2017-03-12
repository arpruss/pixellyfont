import sys
import re

def process(name):
    with open(name) as f:
        for line in f:
            m = re.match(r'include\s+<([^>]+)>', line)
            if m:
                process(m.group(1))
            else:
                print line.strip()
                
process(sys.argv[1])                