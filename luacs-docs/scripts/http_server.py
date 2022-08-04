import os
import http.server
import argparse

def Route(s):
    try:
        prefix, root = s.split(":", 1)
    except:
        raise argparse.ArgumentTypeError("Route mapping must be in the <prefix>:<root> format: " + s)
    return (prefix, root)

parser = argparse.ArgumentParser()
parser.add_argument("root", type=str)
parser.add_argument("--port", type=int, default=8000)
parser.add_argument("--route", type=Route, dest="routes", action="extend", nargs="*")

class RequestHandler(http.server.SimpleHTTPRequestHandler):
    base_dir = None
    routes = []
    def translate_path(self, path):
        path.lstrip()
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
    args = parser.parse_args()

    # Make sure we have at least one route
    if not args.routes:
        args.routes = [("/", "")]

    # Routes listed first should have precedence over the rest
    args.routes.reverse()

    RequestHandler.base_dir = args.root
    RequestHandler.routes = args.routes
    port = args.port

    httpd = http.server.HTTPServer(("127.0.0.1", port), RequestHandler)
    print(f"Listening on port {port} (http://127.0.0.1:{port})")
    httpd.serve_forever()
