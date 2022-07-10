python
import os, subprocess, sys
PY_LOC = '/opt/pyenv/shims/python3'
try:
    gdb_python_version = sys.version.split()[0]
    shell_python_version = subprocess.check_output(PY_LOC +' -c "import sys;print(sys.version.split()[0])"', shell=True).decode("utf-8").strip()
    if gdb_python_version == shell_python_version:
        # Execute a Python using the user's shell and pull out the sys.path (for site-packages)
        shell_paths = subprocess.check_output(PY_LOC + ' -c "import os,sys;print(os.linesep.join(sys.path).strip())"', shell=True).decode("utf-8").split()
        # Extend GDB's Python's search path
        sys.path.extend(path for path in shell_paths if not path in sys.path)
        print("Included shell Python path")
    else:
        print("Failed to include shell Python path: Python version mismatch (shell {}, gdb {})".format(shell_python_version, gdb_python_version))
except Exception as e:
    print("Failed to include shell Python path: " + str(e))
end

source /opt/pwndbg/gdbinit.py
