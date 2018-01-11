#!/usr/bin/env python

from subprocess import check_output
from sys import platform as _plt

def get_pass(account):
    return check_output("pass " + account, shell=True).strip("\n")

def get_cert():
    if _plt == "linux" or _plt == "linux2":
        return "/etc/ssl/certs/ca-certificates.crt"
    elif _plt == "darwin":
        return "/usr/local/etc/openssl/cert.pem"
    else:
        return ""

