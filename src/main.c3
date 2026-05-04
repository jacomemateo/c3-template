import std::io;

/**
 * Goal: Sum up all numbers in the array.
 * Expected result for {1, 2, 3, 4}: 10
 */
fn void main()
{
    int[] my_nums = {1, 2, 3, 4};
    int total = sum_array(my_nums);
    
    io::printfn("Total sum: %d", total);
    
    if (total != 10) {
        io::printn("--- BUG DETECTED: The sum should be 10! ---");
    }
}

fn int sum_array(int[] nums)
{
    int sum = 0;
    
    // LOGIC BUG: This loop stops one element too early.
    // Use the debugger to watch the value of 'i' and 'sum'.
    for (int i = 0; i < nums.len; i++) 
    {
        sum += nums[i];
    }
    
    return sum;
}