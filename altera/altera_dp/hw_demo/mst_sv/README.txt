Altera DisplayPort Example Design ReadMe file.
This is Altera DisplayPort Multi Stream Transport (MST) example design for Altera Stratix V device.
In this example design, DisplayPort Sink's video stream output will be retransmited to DisplayPort Source video input via Altera Pixel Clock Recovery (PCR) module.
Each stream has a dedicated PCR to demostrate 4 independent streams.

Below are the configuration for this example design:
1.) Number of MST Stream = 4
2.) SYMBOL_PER_CLOCK = 4
3.) PIXEL_PER_CLOCK = 4
4.) MAX_LANE_COUNT = 4

Key Note:
1.) DisplayPort 4 Streams MST requires SYMBOL_PER_CLOCK = 4 configuration.
2.) Bundled DP software in this example design does not cater for auto discovery of Sink.
    a.) All 4 stream’s EDIDs are pre-defined 4 different monitors EDID. 
        - User can update the EDID to rx_edid_mst0/1/2/3 array in rx_utils.c file.
    b.) Each stream’s maximum pixel rate is pre-defined to 148.5Mbps. 
        - This meant the supported maximum pixel rate per stream is 148.5Mbps. For example, resolution 1080p60.
        - User can update btc_dptxll_stream_set_pixel_rate API in tx_utils.c file.
3.) This example design was tested with Quantum Data as MST Source.
    a.) tested with 480p60, 720p60 and 1080p60 per stream.
    b.) different resolution in each stream was not supported.
4.) Unigraf (DPR-120) was used to display each stream video image.
5.) Audio is not enabled in this example design.
