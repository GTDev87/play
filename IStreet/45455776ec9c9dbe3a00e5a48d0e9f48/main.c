#include <stdio.h>
#include <string.h>

int int_from_stdin(){
  int digit;
  scanf("%d", &digit);
  return digit;
}

void get_testcase(int size, int* testcase){
  int index;
  for(index = 0; index < size; ++index){
    testcase[index] = int_from_stdin();
  }
}

void bitmask_to_testcase(int bitmask, int* testcase, int* testcase_subarray){
  int index = 0;
  int index_array_index = 0;
  while(bitmask > 0){
    if(bitmask & 1){
      testcase_subarray[index_array_index] = testcase[index];
      index_array_index++;
    }
    index++;
    bitmask = bitmask >> 1;
  }
  testcase_subarray[index_array_index] = -1;
  testcase_subarray[index_array_index+1] = -1;
  testcase_subarray[index_array_index+2] = -1;
}

int is_sorted(int* testcase, int index){
  int x, y;
  if(testcase[index] == -1|| testcase[index+1] == -1){
    return 1;
  }else{
    if(testcase[index] > testcase[index+1]){
      return 0;
    }else{
      is_sorted(testcase, index+1);
    }
  }
}

int almost_sorted(int* testcase, int index){
  int x, y, z;

  if(testcase[index] == -1 || testcase[index+1] == -1 || testcase[index+2] == -1){
    return 1;
  }else{
    x = testcase[index];
    y = testcase[index+1];
    z = testcase[index+2];
    if(x > y){
      return is_sorted(testcase, index+1);
    }
    if(x > z){
      testcase[index+1] = x;
      testcase[index+2] = y;
      return is_sorted(testcase, index+1);
    }
    if(y > z){
      testcase[index+1] = x;
      return is_sorted(testcase, index+1);
    }
    return almost_sorted(testcase, index+1);
  }
}

int player_wins(int* testcase, int bitmask, int test_size){
  int testcase_subarray[test_size + 3];
  bitmask_to_testcase(bitmask, testcase, testcase_subarray);
  return almost_sorted(testcase_subarray, 0);
}

int solve_for_player(int* testcase, int bitmask, int test_size, char* sol_map){
  int sub_array_index, bitmask_index;
  int i;
  if(sol_map[bitmask] == 1){
     return 1;
  }

  if(sol_map[bitmask] == 2){
     return 0;
  }
  
  if(player_wins(testcase, bitmask, test_size)){
    sol_map[bitmask] = 1;
    return 1;
  }else{
    for(sub_array_index = 0; sub_array_index < test_size; ++sub_array_index){
      bitmask_index = (1 << sub_array_index);
      if(bitmask & bitmask_index){
        if(!solve_for_player(testcase, bitmask ^ bitmask_index, test_size, sol_map)){
          sol_map[bitmask] = 1;
          return 1;
        }
      }
    }
    sol_map[bitmask] = 2;
    return 0;
  }
}

print_alice(int is_alice){
  if(is_alice){
    printf("Alice\n");
  }else{
    printf("Bob\n");
  }
}

void solve_testcase(int array_size){
  int index, initial_bitmask;
  int testcase[array_size];
  get_testcase(array_size, testcase);
  int mapsize = 1 << array_size;
  char solution_map[mapsize];
  memset(solution_map, 0, mapsize);
  initial_bitmask = ((1 << array_size) -1);
  print_alice(solve_for_player(testcase, initial_bitmask,array_size,solution_map)); 
}

void solve_testcases(int num_cases){
  int case_indx;
  for(case_indx = 0; case_indx < num_cases; ++case_indx){
     solve_testcase(int_from_stdin());
  }
}

int main() {
  solve_testcases(int_from_stdin());
  return 0;
}
