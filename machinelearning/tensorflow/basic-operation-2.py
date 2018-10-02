import tensorflow as tf
import os

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

print("##Example 1: matrix : addtion: a + b")
a   = tf.constant([[1,2],[3,4]])
b   = tf.constant([[5,6],[7,8]])
add = a + b
with tf.Session() as sess:
  print("a = \n" + str(sess.run(a)))
  print("b = \n" + str(sess.run(b)))
  print("a + b = \n" + str(sess.run(add)))

print("\n##Example 2: matrix : subtract: b - a")
a   = tf.constant([[1,2],[3,4]])
b   = tf.constant([[5,6],[7,8]])
sub = tf.subtract(b,a)
with tf.Session() as sess:
  print("a = \n" + str(sess.run(a)))
  print("b = \n" + str(sess.run(b)))
  print("tf.subtract(b,a)  = \n" + str(sess.run(sub)))

print("\n##Example 3: matrix : multiply: a*b")
a   = tf.constant([[1,2],[3,4]])
b   = tf.constant([[5,6],[7,8]])
mul = tf.matmul(a,b)
with tf.Session() as sess:
  print("a = \n" + str(sess.run(a)))
  print("b = \n" + str(sess.run(b)))
  print("tf.matmul(a,b)  = \n" + str(sess.run(mul)))

print("\n##Example 4: matrix : inverse matrix of a: ")
a       = tf.constant([[1.,2.],[3.,4.]])
inverse = tf.matrix_inverse(a)
with tf.Session() as sess:
  print("a = \n" + str(sess.run(a)))
  print("tf.matrix_inverse(a)  = \n" + str(sess.run(inverse)))

print("\n##Example 5: matrix : transpose matrix of a: ")
a         = tf.constant([[1.,2.],[3.,4.]])
transpose = tf.transpose(a)
with tf.Session() as sess:
  print("a = \n" + str(sess.run(a)))
  print("tf.transpose(a)  = \n" + str(sess.run(transpose)))

print("\n##Example 6: matrix : diag matrix of a: ")
a         = tf.constant([1,2,3,4])
diagmatrix= tf.matrix_diag(a)
with tf.Session() as sess:
  print("a = \n" + str(sess.run(a)))
  print("tf.matrix_diag(a)  = \n" + str(sess.run(diagmatrix)))
