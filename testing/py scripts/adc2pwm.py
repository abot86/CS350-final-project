#50kHz sample, 60 Hz wave, 833.3 samples per period, 2500 per 3 periods

BTNL = 1
BTNR = 1

count = 0
totaldiff = 0
prev_totaldiff = 0
diff = 0

input = []

# Wait until rest calibration button pressed
while (True):
    if BTNL != 0:
        break

while (count < 2500):
    
    count += 1
