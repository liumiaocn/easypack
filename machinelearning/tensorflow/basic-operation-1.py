import tensorflow as tf
import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

print("##Example 1: Constant: a + b")
a = tf.constant(2)
b = tf.constant(3)
add = a + b
print("use a + b directly: a = 2,b=3")
print(tf.Session().run(add))

print("\n##Example 2: use tf.add(a,b): a=2,b=3")
add = tf.add(a,b)
print(tf.Session().run(add))

print("")
print("##Example 3: feed_dict + placeholder")
c = tf.placeholder(tf.int32,name="c")
d = tf.placeholder(tf.int32,name="d")
print("c=2,d=0,tf.Session().run(add,feed_dict={c:2,d:0}")
print(tf.Session().run(add,feed_dict={c:2,d:0}))

print("\n##Example 4: feed_data={c:32,d:10}, tf.add(c,d)")
feed_data={c:32,d:10}
add = tf.add(c,d)
print(tf.Session().run(add,feed_dict=feed_data))

print("\n##Example 5: use with statement : expression")
with tf.Session() as session:
  print("a = " + str(session.run(a)))
  print("b = " + str(session.run(b)))
  print("a + b = " + str(session.run(a+b)))
  print("a - b = " + str(session.run(a-b)))
  print("a * b = " + str(session.run(a*b)))
  print("a / b = " + str(session.run(a/b)))

print("\n##Example 6: use with statement : tf.function")
with tf.Session() as session:
  print("a = " + str(session.run(a)))
  print("b = " + str(session.run(b)))
  func=tf.add(a,b)
  print("a + b = " + str(session.run(func)))
  func=tf.subtract(a,b)
  print("a - b = " + str(session.run(func)))
  func=tf.multiply(a,b)
  print("a * b = " + str(session.run(func)))
  func=tf.divide(a,b)
  print("a / b = " + str(session.run(func)))

print("\n##Example 7: y=w*x +b : expression")
with tf.Session() as session:
  w=tf.constant(2)
  b=tf.constant(2)
  x=tf.placeholder(tf.int32)
  y=w*x + b
  print("y=w*x+b=" + str(session.run(y,feed_dict={x:20})))   

print("\n##Example 8: y=w*x +b : tf.function")
with tf.Session() as session:
  w=tf.constant(2)
  b=tf.constant(2)
  x=tf.placeholder(tf.int32)
  y=tf.add(tf.multiply(w,x),b)
  print("y=w*x+b=" + str(session.run(y,feed_dict={x:20})))   
