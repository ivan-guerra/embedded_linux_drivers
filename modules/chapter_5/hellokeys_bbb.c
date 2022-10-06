#include <linux/module.h>
#include <linux/fs.h>
#include <linux/platform_device.h>
#include <linux/mod_devicetable.h>
#include <linux/miscdevice.h>

static int my_dev_open(struct inode *inode, struct file *filp)
{
	pr_info("my_dev_open() is called.\n");
	return 0;
}

static int my_dev_close(struct inode *inode, struct file *filp)
{
	pr_info("m_dev_close() is called.\n");
	return 0;
}

static long my_dev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	pr_info("m_dev_ioctl() is called. cmd = %d, arg = %ld\n", cmd, arg);
	return 0;
}

/* char device file operations. */
static const struct file_operations my_dev_fops = {
	.owner = THIS_MODULE,
	.open = my_dev_open,
	.release = my_dev_close,
	.unlocked_ioctl = my_dev_ioctl,
};

static struct miscdevice helloworld_miscdevice = {
	.minor = MISC_DYNAMIC_MINOR,
	.name = "mydev",
	.fops = &my_dev_fops,
};

static int __init my_probe(struct platform_device *pdev)
{
	int ret;
	pr_info("my_probe() function is called.\n");
	ret = misc_register(&helloworld_miscdevice);
	if (ret) {
		pr_err("could not register the misc device mydev\n");
		return ret;
	}

	pr_info("mydev: got minor %i\n", helloworld_miscdevice.minor);
	return 0;
}

static int __exit my_remove(struct platform_device *pdev)
{
	pr_info("my_remove() function is called.\n");
	misc_deregister(&helloworld_miscdevice);
	return 0;
}

/* Declare the list of device supported by the driver. */
static const struct of_device_id my_of_ids[] = {
	{ .compatible = "arrow,hellokeys" },
	{},
};
MODULE_DEVICE_TABLE(of, my_of_ids);

/* Define platform driver structure. */
static struct platform_driver my_platform_driver = {
    .probe = my_probe,
    .remove = my_remove,
    .driver = {
        .name = "hellokeys",
        .of_match_table = my_of_ids,
        .owner = THIS_MODULE,
    },
};

/* Register your platform driver. */
module_platform_driver(my_platform_driver);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Ivan Guerra <ivan.eduardo.guerra@gmail.com>");
MODULE_DESCRIPTION("This is a simple platform driver.");
