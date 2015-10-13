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
    cores_str = sys.argv[3]
    no_maxjobs = cores_str.replace("maxjobs", "")
    cores = int(no_maxjobs)
    print(width, height, cores)
    p = Pool(cores)
    MAXJOBS=100
    def maxjobs_map(f, items):
        first_i = 0
        result = []
        while first_i < len(items):
            after_last_i = first_i + MAXJOBS
            some_items = items[first_i:after_last_i]
            result += p.map(f, some_items)
            first_i += MAXJOBS
        return result
    if cores == 1:
        MAP = map
    else:
        if "maxjobs" in cores_str:
            MAP = maxjobs_map
        else:
            MAP = p.map
    if height == 1:
        base_list = list(range(width))
        MAP(returnNone, base_list)
    else:
        base_list = [list(range(height)) for x in range(width)]
        MAP(returnList, base_list)
