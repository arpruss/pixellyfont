import sys
import re

output = []
params = []
current = output

def process(name):
    global current
    with open(name) as f:
        for line in f:
            m = re.match(r'include\s+<([^>]+)>', line)
            if m:
                current.append("//"+line.strip())
                process(m.group(1))
            else:
                line = line.strip()
                if line == "//<params>":
                    current = params
                elif line == "//</params>":
                    current = output
                else:
                    current.append(line.strip())
                
process(sys.argv[1])
if params:
    params.append("\nmodule end_of_parameters_dummy() {}\n")
print "\n".join(params+output)
