import subprocess

def lambda_handler(event, context):
    subprocess.run("ldd /opt/bin/wkhtmltopdf".split(), check=True)

    subprocess.run("wkhtmltopdf -V".split(), check=True)