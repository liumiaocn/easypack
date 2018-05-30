import requests
import datetime
from pyramid.response import Response
from pyramid.view import view_config
from pyramid.config import Configurator
from py_zipkin.zipkin import create_http_headers_for_new_span
from wsgiref.simple_server import make_server

class ZipkinNode:
  #properties:
  connect_url='http://localhost:9001/api'
  zipkin_url='http://localhost:9411'
  zipkin_span_api=zipkin_url+'/api/v1/spans'
  zipkin_service_name='default_service_name'
  config=None

  #function: zikpin callback handler
  def zipkin_handler(self,stream_name, encoded_span):
    requests.post(
        self.zipkin_span_api,
        data=encoded_span,
        headers={'Content-Type': 'application/x-thrift'},
    )  

  #function: 
  def init_zipkin_settings(self,service_name): 
    settings = {}
    settings['service_name'] = service_name
    self.zipkin_service_name=service_name
    settings['zipkin.transport_handler'] = self.zipkin_handler
    settings['zipkin.tracing_percent'] = 100.0

    self.config = Configurator(settings=settings)
    self.config.include('pyramid_zipkin')

  #function: add route
  def add_router(self,router_type,router_url):
    self.config.add_route(router_type, router_url)
    #self.config.add_view('show_time','/api')

  #function: 
  def invoke_wsgi_service(self,host_port):
    self.config.scan()
    app = self.config.make_wsgi_app()
    server = make_server('0.0.0.0', host_port, app)
    print('service '+self.zipkin_service_name+' listening : http://localhost:'+str(host_port))
    server.serve_forever()

#function: connector node callback function
@view_config(route_name='invoke_service')
def invoke_service(request):
  headers = {}
  headers.update(create_http_headers_for_new_span())
  nextend_response = requests.get(
      'http://localhost:9004/api',
      headers=headers,
  )

  headers = {}
  headers.update(create_http_headers_for_new_span())
  nextend_response = requests.get(
      'http://localhost:9005/api',
      headers=headers,
  )
  return Response(nextend_response.text)

node=ZipkinNode()
node.init_zipkin_settings('Service_C')
node.add_router('invoke_service','/api')
node.invoke_wsgi_service(9003)
