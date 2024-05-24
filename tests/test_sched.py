import sched
import time

def my_function(event_num):
    print(f"Function {event_num} executed!")

# Create a scheduler object
scheduler = sched.scheduler(time.time, time.sleep)

# Define the number of events
num_events = 10000  # Adjust this number based on your testing needs

# Schedule multiple events
for i in range(num_events):
    scheduler.enter(0, 1, my_function, argument=(i,))

# Run the scheduler
start_time = time.time()
try:
    scheduler.run()
except MemoryError:
    print("MemoryError: The scheduler has reached its limit.")
end_time = time.time()

print(f"Scheduled and executed {num_events} events in {end_time - start_time} seconds.")
