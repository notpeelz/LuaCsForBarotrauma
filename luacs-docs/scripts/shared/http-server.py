import os
import sys
import signal
import http.server
from http.server import SimpleHTTPRequestHandler
import argparse

def Route(s):
    try:
        prefix, root = s.split(":", 1)
    except:
        raise argparse.ArgumentTypeError("Route mapping must be in the <prefix>:<root> format: " + s)
    return (prefix, root)

parser = argparse.ArgumentParser()
parser.add_argument("root", type=str)
parser.add_argument("--host", type=str, required=True)
parser.add_argument("--port", type=int, required=True)
parser.add_argument("--route", type=Route, dest="routes", action="extend", nargs="*")

class RequestHandler(SimpleHTTPRequestHandler):
    base_dir = None
    routes = []

    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        SimpleHTTPRequestHandler.end_headers(self)

    def do_GET(self):
        if '?' in self.path:
            self.path = self.path.split('?')[0]
        SimpleHTTPRequestHandler.do_GET(self)

    def translate_path(self, path):
        path.lstrip()
        root = None
        for prefix, rootDir in self.routes:
            if path.startswith(prefix):
                # print("matched route: " + prefix)
                path = path[len(prefix):]
                root = rootDir
                break

        path.lstrip()
        if root == None:
            raise Exception("No route matches path: " + path)

        # Make sure we don't have a path that starts with /, otherwise
        # os.path.join() would resolve it to the root of the filesystem.
        if path.startswith("/"):
            path = "." + path

        resolved_path = os.path.join(self.base_dir, root, path)

        # print("base_dir: " + self.base_dir)
        # print("root: " + root)
        # print("path: " + path)
        # print("resolved_path: " + resolved_path)

        return resolved_path

if __name__ == "__main__":
    def signal_handler(sig, frame):
        print()
        sys.exit(128 + sig)

    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)

    args = parser.parse_args()

    if not args.routes:
        args.routes = []

    if not [x for x in args.routes if x[0] == "/"]:
        args.routes = [("/", "")]

    # Routes listed first should have precedence over the rest
    args.routes.reverse()

    RequestHandler.base_dir = args.root
    RequestHandler.routes = args.routes

    host = args.host
    port = args.port

    httpd = http.server.HTTPServer((host, port), RequestHandler)
    httpd.serve_forever()
