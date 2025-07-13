from ranger.api.commands import Command

class mount(Command):
    """:mount.

    Show menu to mount and unmount.
    """

    MMTUI_PATH = "mmtui"

    def execute(self):
        """Show menu to mount and unmount."""
        import os
        import tempfile
        (f, p) = tempfile.mkstemp()
        os.close(f)
        self.fm.execute_console(
            f'shell bash -c "{self.MMTUI_PATH} 1> {p}"'
        )
        with open(p, 'r') as f:
            d = f.readline().strip()
            if os.path.exists(d):
                self.fm.cd(d)
        os.remove(p)
