def total_cost(adult, senior, child):
  cpc = 4.0 # Cost per child
  if (child >= 4):
    cpc = 3.5
  return adult * 7 + child * cpc + senior * 5

adult = float(input("Enter number of adult tickets: "))
senior = float(input("Enter number of senior tickets: "))
child = float(input("Enter number of child tickets: "))

print('Total Cost:', '$' + str(total_cost(adult, senior, child)))
