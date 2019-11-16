from server import app

import os

if __name__ == '__main__':
    os.environ[f'MY_PID_{os.getpid()}'] = '1'
    app.run()

