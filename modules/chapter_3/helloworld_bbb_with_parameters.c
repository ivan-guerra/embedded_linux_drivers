#include <linux/module.h>

static int num = 5;

module_param(num, int, S_IRUGO);

static int __init hello_init(void)
{
	pr_info("parameter num = %d\n", num);
	return 0;
}

static __exit void hello_exit(void)
{
	pr_info("Hello world with parameter exit\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ivan Guerra <ivan.eduardo.guerra@gmail.com");
MODULE_DESCRIPTION("This is a module that accepts parameters.");
