import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


segments = [ 63, 6, 91, 79, 102, 109, 124, 7, 127, 103 ]

@cocotb.test()
async def test_lif(dut):

    CONSTANT_CURRENT = 100 # Inject a constant current
    WEAKER_CONSTANT_CURRENT = 50 # Inject a weaker current
    NO_CURRENT = 25 # Almost No current

    dut._log.info("start")

    # initialize clock
    clock = Clock(dut.clk,1,units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # take out of reset


# BASIC TEST
    dut.ui_in.value = CONSTANT_CURRENT
    dut.ena.value = 1 # enable design
    dut.uio_in.value = 3

    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut.ui_in.value = WEAKER_CONSTANT_CURRENT
    
    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut.ui_in.value = NO_CURRENT

    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)







    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # take out of reset

# # TURN ADAPTIVE BETA OFF
    dut.ui_in.value = CONSTANT_CURRENT
    dut.uio_in.value = 1

    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut.ui_in.value = WEAKER_CONSTANT_CURRENT
    
    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut.ui_in.value = NO_CURRENT

    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)





    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # take out of reset

# # TURN ADAPTIVE THRESHOLD OFF
    dut.ui_in.value = CONSTANT_CURRENT
    dut.uio_in.value = 2

    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut.ui_in.value = WEAKER_CONSTANT_CURRENT
    
    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut.ui_in.value = NO_CURRENT

    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)




    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # take out of reset

# # TURN ADAPTIVE OFF
    dut.ui_in.value = CONSTANT_CURRENT
    dut.uio_in.value = 0

    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut.ui_in.value = WEAKER_CONSTANT_CURRENT
    
    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut.ui_in.value = NO_CURRENT

    for _ in range(200): # run for 200 clock cycle
        await RisingEdge(dut.clk)

    dut._log.info("Finished Test!")