extends Node
var thread: Thread

# The thread will start here.
func _ready():
	thread = Thread.new()
	# You can bind multiple arguments to a function Callable.
	thread.start(_thread_function.bind("Wafflecopter"))


# Run here and exit.
# The argument is the bound data passed from start().
func _thread_function(userdata):
	# Print the userdata ("Wafflecopter")
	print("I'm a thread! Userdata is: ", userdata)


# Thread must be disposed (or "joined"), for portability.
func _exit_tree():
	thread.wait_to_finish()
