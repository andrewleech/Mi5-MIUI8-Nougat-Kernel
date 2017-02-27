#include <linux/fs.h>
#include <linux/init.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <asm/setup.h>

static char proc_cmdline[COMMAND_LINE_SIZE];
static char proc_cmdline_temp[COMMAND_LINE_SIZE];

static int cmdline_proc_show(struct seq_file *m, void *v)
{
	seq_printf(m, "%s\n", proc_cmdline);
	return 0;
}

static int cmdline_proc_open(struct inode *inode, struct file *file)
{
	return single_open(file, cmdline_proc_show, NULL);
}

static const struct file_operations cmdline_proc_fops = {
	.open		= cmdline_proc_open,
	.read		= seq_read,
	.llseek		= seq_lseek,
	.release	= single_release,
};

static int __init proc_cmdline_init(void)
{
	/* SafetyNet bypass: show androidboot.verifiedbootstate=green */
	char *a1, *a2;

	a1 = strstr(saved_command_line, "androidboot.verifiedbootstate=");
	if (a1) {
		a1 = strchr(a1, '=');
		a2 = strchr(a1, ' ');
		if (!a2) /* last argument on the cmdline */
			a2 = "";

		scnprintf(proc_cmdline_temp, COMMAND_LINE_SIZE, "%.*sgreen%s",
			  (int)(a1 - saved_command_line + 1),
			  saved_command_line, a2);
	} else {
		strncpy(proc_cmdline_temp, saved_command_line, COMMAND_LINE_SIZE);
	}

	a1 = strstr(proc_cmdline_temp, "androidboot.veritymode=");
	if (a1) {
		a1 = strchr(a1, '=');
		a2 = strchr(a1, ' ');
		if (!a2) // last argument on the cmdline
			a2 = "";

		scnprintf(proc_cmdline, COMMAND_LINE_SIZE, "%.*senforcing%s",
			  (int)(a1 - proc_cmdline_temp + 1),
			  proc_cmdline_temp, a2);
	} else {
		strncpy(proc_cmdline, proc_cmdline_temp, COMMAND_LINE_SIZE);
	}

//        scnprintf(proc_cmdline, COMMAND_LINE_SIZE, "%s androidboot.bl_state=0 androidboot.flash.locked=1", proc_cmdline_temp);

	proc_create("cmdline", 0, NULL, &cmdline_proc_fops);
	return 0;
}
fs_initcall(proc_cmdline_init);
