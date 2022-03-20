# Debugging Notes

## Serial Debug Console - great for boot issues

[Described here](https://www.jetsonhacks.com/2019/04/19/jetson-nano-serial-console/)

[The cable you need is here](https://www.amazon.com/gp/product/B00DJUHGHI/ref=ppx_yo_dt_b_asin_title_o05_s00?ie=UTF8&psc=1)
    

## Debugging crashing JupyterLAB notebook

Symptoms:
    When running the first cell in the jupyter/gpucheck-torch.ipynb, the kernel would silently crash, no clues in the usual system logs.. 
    Also reproduced from iPython command line, so nothing to do with JupyterLAB:

    python -c 'import torch'

Caused a core dump! Let's debug it!

Create a test file (~/jetson-nano-dev/pytest.py):

    import torch

Now run it from gdb:

    (gdb) run ~/jetson-nano-dev/pytest.py
    Starting program: /home/aaron/venv/py3.6.9_PyTorch_jp4.4.1/bin/python ~/jetson-nano-dev/pytest.py
    [Thread debugging using libthread_db enabled]
    Using host libthread_db library "/lib/aarch64-linux-gnu/libthread_db.so.1".
    [New Thread 0x7f6be6d170 (LWP 7677)]
    [New Thread 0x7f6a66c170 (LWP 7683)]
    [New Thread 0x7f68e6b170 (LWP 7684)]

    Thread 1 "python" received signal SIGILL, Illegal instruction.
    0x0000007f65cfef54 in gotoblas_dynamic_init ()
    from /home/aaron/venv/py3.6.9_PyTorch_jp4.4.1/lib/python3.6/site-packages/numpy/core/../../numpy.libs/libopenblasp-r0-32ff4d91.3.13.so

This gave me the extra info I needed to grep around google for the solution:

OPENBLAS_CORETYPE=ARMV8 python3 -c 'import torch'

Fixed the issue!

While I'm in here...Let's look at the backtrace:

    (gdb) bt
    #0  0x0000007f65cfef54 in gotoblas_dynamic_init ()
    from /home/aaron/venv/py3.6.9_PyTorch_jp4.4.1/lib/python3.6/site-packages/numpy/core/../../numpy.libs/libopenblasp-r0-32ff4d91.3.13.so
    #1  0x0000007f65b8172c in gotoblas_init ()
    from /home/aaron/venv/py3.6.9_PyTorch_jp4.4.1/lib/python3.6/site-packages/numpy/core/../../numpy.libs/libopenblasp-r0-32ff4d91.3.13.so
    #2  0x0000007fb7fdf8f4 in call_init (l=<optimized out>, argc=argc@entry=2, argv=argv@entry=0x7ffffff158, env=env@entry=0x5557f85ef0) at dl-init.c:72
    #3  0x0000007fb7fdf9f8 in call_init (env=0x5557f85ef0, argv=0x7ffffff158, argc=2, l=<optimized out>) at dl-init.c:118

    ... <lines deleted as it's very long>

## Other useful things:

    jupyter kernelspec list --json

    sudo tail -f /var/log/{messages,kernel,dmesg,syslog}


