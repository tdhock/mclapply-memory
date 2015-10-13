# usage:
# python multiprocess.py [width] [height] [cores]
# if cores == 1, multiprocessing library not used

import sys
from multiprocessing import Pool

def returnNone(x):
    return None

def returnList(x):
    return [None for x in x]

if __name__ == '__main__':
    width = int(sys.argv[1])
    height = int(sys.argv[2])
    cores = int(sys.argv[3])
    print(width, height, cores)
    if height == 1:
        base_list = list(range(width))
    else:
        base_list = [list(range(height)) for x in range(width)]

    if cores == 1:
        if height == 1:
            print "returnNone map"
            result = list(map(returnNone, base_list))
        else:
            print "returnList map"
            result = list(map(returnList, base_list))
    else:
        p = Pool(cores)
        if height == 1:
            print "returnNone Pool.map"
            result = p.map(returnNone, base_list)
        else:
            print "returnList Pool.map"
            result = p.map(returnList, base_list)
        
