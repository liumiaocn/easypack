import tornado.ioloop
import tornado.web
import sys
import socket

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        host_name = socket.gethostname()
        self.write("Host Name: " + host_name + " : " + sys.argv[1] + "\n")

def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ])

if __name__ == "__main__":
    app = make_app()
    app.listen(sys.argv[2])
    tornado.ioloop.IOLoop.current().start()
