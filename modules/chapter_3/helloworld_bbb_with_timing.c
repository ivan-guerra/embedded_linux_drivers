#include <linux/module.h>
#include <linux/time.h>

static int num = 5;
static struct timeval start_time;
module_param(num, int, S_IRUGO);

static void say_hello(void)
{
	for (int i = 1; i <= num; ++i)
		pr_info("[%d/%d] Hello!", i, num);
}

static int __init first_init(void)
{
	do_gettimeofday(&start_time);
	pr_info("Loading first!\n");
	say_hello();
	return 0;
}

static __exit void first_exit(void)
{
	struct timeval end_time;
	do_gettimeofday(&end_time);
	pr_info("Unloading module after %ld seconds\n",
		end_time.tv_sec - start_time.tv_sec);
	say_hello();
}

module_init(first_init);
module_exit(first_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ivan Guerra <ivan.eduardo.guerra@gmail.com");
MODULE_DESCRIPTION("This is a module that will print the time since it was \
                    loaded.");
