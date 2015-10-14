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
    no_text = cores_str[:1]
    only_text = cores_str[1:]
    cores = int(no_text)
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
    
    def chunksize_map(f, items):
        return p.map(f, items, MAXJOBS)
    
    if cores == 1:
        MAP = map
    else:
        if "maxjobs" in cores_str:
            MAP = maxjobs_map
        elif "chunksize" in cores_str:
            MAP = chunksize_map
        else:
            MAP = p.map
    print(width, height, cores, MAP)
    if height == 1:
        base_list = list(range(width))
        MAP(returnNone, base_list)
    else:
        base_list = [list(range(height)) for x in range(width)]
        MAP(returnList, base_list)
