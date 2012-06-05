def parse_line_into_int_array():
    return [int(parsed_int) for parsed_int in raw_input().split(" ") if parsed_int != ""]

class RemovalCollection:
    def __init__(self, contiguous_billboards):
        self.deletion_dictionary = {}
        self.contiguous_billboards = contiguous_billboards
        
    def add_new_removal(self, position, value):
        self.__clean_old_and_unnecessary_removals(position, value)
        self.deletion_dictionary[position] = value
        
    def __clean_old_and_unnecessary_removals(self, current_position, current_deletion_value):
        for position, value in self.deletion_dictionary.items():
            if (position < current_position - self.contiguous_billboards) or (current_deletion_value <= value):
                del self.deletion_dictionary[position]
    
    def find_minimum(self):
        return self.deletion_dictionary[min(self.deletion_dictionary, key = self.deletion_dictionary.get)]
                    
def solve_billboards(number_billboards, contiguous_billboards):
    
    largest_billboard_distance = contiguous_billboards + 1
    removals = RemovalCollection(contiguous_billboards)
    all_billboards_value = 0

    for i in range(0,number_billboards):
        billboard_value = parse_line_into_int_array()[0]
        all_billboards_value += billboard_value

        if i < largest_billboard_distance:
            current_deletion_value = billboard_value
        else:
            current_deletion_value = removals.find_minimum() + billboard_value

        removals.add_new_removal(i,current_deletion_value)
    
    return all_billboards_value - removals.find_minimum()
    
if __name__ == "__main__":
    first_line = parse_line_into_int_array()
    print solve_billboards(first_line[0], first_line[1])
