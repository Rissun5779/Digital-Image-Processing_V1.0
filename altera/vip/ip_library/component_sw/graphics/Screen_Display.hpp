#ifndef __SCREEN_DISPLAY_HPP__
#define __SCREEN_DISPLAY_HPP__

#include <io.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#define PI 3.14159265f


enum {brd_left, brd_right, brd_single, brd_clear};


class Screen_Display {
private:

	struct horiz_node {
			short x;
			// border_property
			// 0-left, 1-right, 2-single(non-paired) left node
			// Insert node with invert edge for clearing
			unsigned char border_property;
			horiz_node* next;
			unsigned int color;
			bool is_clean;
	};	// end of structure horiz_node

	long frame_addr[2];
	int width[2];
	int height[2];
	int r;
	int g;
	int b;
	int alpha;
	int color;

	horiz_node* screen_map;		// All the first node in a line are header(non-valid)
	int screen_map_width;
	int screen_map_height;
	int screen_map_xoffset;
	int screen_map_yoffset;



	/***********************************************
	 * Utility function
	 **********************************************/
	int min(int a, int b)
	{
		return (a<b)? a:b;
	}

	int max(int a, int b)
	{
		return (a>b)? a:b;
	}

	bool is_between(int input, int bound0, int bound1)
	{
		return ( ((input>=bound0)&&(input<=bound1)) || ((input<=bound0)&&(input>=bound1)) );
	}

	int delta_theta(int angle0, int angle1)
	// return the angular distance in degree between two angles.
	{
		return (angle1-angle0+360)%360;
	}


	/************************************************
	 * Functions for accessing the screen_map list
	 ***********************************************/
	void insert_node(short x, short y, int border_property,
					int pixel_color=-1)
	{

		// The list is sorted in ascending order
		// hence look for node with x value that just before the current x value.
		horiz_node* right_most_node = screen_map+y;
		horiz_node* tmp_node = right_most_node->next;
		unsigned int pcl = (pixel_color<0)?color:pixel_color;

		while (tmp_node != NULL && (tmp_node->x <= x || tmp_node->color!= pcl)) {
				right_most_node = tmp_node;
				tmp_node = tmp_node->next;
		}

		tmp_node = new horiz_node;
		tmp_node->next = right_most_node->next;
		right_most_node->next = tmp_node;
		tmp_node->x = x;
		tmp_node->border_property = border_property ;
		tmp_node->color = pcl;
		tmp_node->is_clean = false;

	}


	void delete_node(horiz_node* previous_node) {
		horiz_node* delete_node = previous_node->next;
		if (delete_node != NULL) {
			previous_node->next = delete_node->next;
			delete delete_node;
		}
	}




public:


	/************************************************
	 *
	 * Setup function
	 *
	 ***********************************************/

	Screen_Display(long frame_address_0, long frame_address_1=-1) 
	{
		frame_addr[0] = frame_address_0;
		frame_addr[1] = frame_address_1;
		width[0] = 0;
		width[1] = 0;
		height[0] = 0;
		height[1] = 0;
		screen_map = NULL;
		screen_map_xoffset = 0;
		screen_map_yoffset = 0;
		screen_map_width = 0;
		screen_map_height = 0;
		alpha = 0xFF;
		r = 0x00;
		g = 0x00;
		b = 0x00;
		color = 0x000000FF;
	}

	~Screen_Display() {
		clear_screen_map();
		delete screen_map;
	}

	void set_frame_size0(int frame_width, int frame_height)
	{
		set_frame_size(0, frame_width, frame_height);
	}
	
	void set_frame_size1(int frame_width, int frame_height)
	{
		set_frame_size(1, frame_width, frame_height);
	}

	void set_frame_size(int frame_index, int frame_width, int frame_height)
	{
		width[frame_index] = frame_width;
		height[frame_index] = frame_height;
	}

	void initial_screen_map(int sm_width, int sm_height)
	{
		screen_map_height = min(sm_height, max(height[0], height[1]));
		screen_map_width = min(sm_width, max(width[0], width[1]));
		screen_map = new horiz_node[screen_map_height];

		// All the first node in a line are header (non-valid)
		for (int i=0; i<screen_map_height; i++){
			screen_map[i].x = -1;
			screen_map[i].next = NULL;
		}
	}

	void set_screen_map_position(int x, int y)
	{
		screen_map_xoffset = x;
		screen_map_yoffset = y;
	}




	/**********************************************
	 *
	 * Basic drawing function
	 *
	 *********************************************/

	void set_pixel(int frame_index, int x, int y, int pixel_color=-1)
	{

		/* Four color planes in a pixel use all 32 bits in a word, every four pixle also use a
		*  whole memory word (128 bits in the design), which make align easy. Here simply write
		*  to the memory without detecting the boundaries of the 32bit word.
		*/
		if ( (x>=0 && x< width[frame_index]) && (y>=0 && y< height[frame_index]) )
			IOWR(this->frame_addr[frame_index], (x+y*width[frame_index]), (pixel_color<0)?color:pixel_color);
	}


	void set_pixel_blend(int frame_index, int x, int y, int red=-1, int green=-1, int blue=-1, int alpha_value=-1)
	{

		unsigned int pixel_value;
		if (red<0||green<0||blue<0||alpha_value<0) {
			pixel_value = color;
		} else {
			unsigned int cRed   = red & 0x000000FF;
			unsigned int cGreen = green & 0x000000FF;
			unsigned int cBlue  = blue & 0x000000FF;
			unsigned int cAlp  = alpha_value & 0x000000FF;
			pixel_value = cRed << 24 | cGreen << 18 | cBlue << 8 | cAlp;
		}

		/* Four color planes in a pixel use all 32 bits in a word, every four pixle also use a
		*  whole memory word (128 bits in the design), which make align easy. Here simply write
		*  to the memory without detecting the boundaries of the 32bit word.
		*/
		if ( (x>=0 && x< width[frame_index]) && (y>=0 && y< height[frame_index]) )
			IOWR(this->frame_addr[frame_index], (x+y*width[frame_index]), pixel_value);
	}




	void set_color(int red, int green, int blue, int alpha_value=0)
	{
		r = red & 0x000000FF;
		g = green & 0x000000FF;
		b = blue & 0x000000FF;
		alpha = alpha_value & 0x000000FF;
		color = r << 24 | g << 16 | b << 8 | alpha;
	}

	void set_color(int color_RGB_ALPHA){
		color = color_RGB_ALPHA;
		r = (color & 0xFF000000) >> 24;
		g = (color & 0x00FF0000) >> 16;
		b = (color & 0x0000FF00) >> 8;
		alpha = color & 0x000000FF;
	}

	int get_color()
	{
		return color;
	}


	void clear_screen(int frame_index=0, int clear_color = 0x000000FF)
	{

		for (int i=0; i<(width[frame_index]*height[frame_index]); i++) {
			IOWR(this->frame_addr[frame_index], i, clear_color);
		}
	}

	void clear_segment(int frame_index, int x0, int y0, int x1, int y1, int clear_color = 0x000000FF)
	{

		int xs = max(0, min(x0, x1));
		int ys = max(0, min(y0, y1));
		int xe = min(width[frame_index], max(x0, x1));
		int ye = min(height[frame_index], max(y0, y1));
		for (int i=ys; i<ye; i++) {
			for (int n=xs; n<xe; n++) {
				IOWR(this->frame_addr[frame_index], n+i*width[frame_index], clear_color);
			}
		}
	}


	 void draw_line(int frame_index, int x0, int y0, int x1, int y1) {

		if ((x0==x1) || (y0==y1)) {

			if (x0==x1) {
				const int yl = min(y0, y1);
				const int yh = max(y0, y1);
				for (int n=yl; n<=yh; n++)
				{
					set_pixel(frame_index, x0, n);
				}
			} else {
				const int xl = min(x0, x1);
				const int xh = max(x0, x1);
				for (int n=xl; n<=xh; n++) {
					set_pixel(frame_index, n, y0);
				}
			}
		} else {
			int dx = (int)abs(x1-x0);
			int dy = (int)abs(y1-y0);
			int x_step, y_step, error, error2;
			if (x0 < x1)
				x_step = 1;
			else
				x_step = -1;

			if (y0 < y1)
				y_step = 1;
			else
				y_step = -1;

			error = dx - dy;

			while(true) {
				 set_pixel(frame_index, x0, y0);
				 if (x0==x1 && y0==y1) break;
				 error2 = 2*error;
				 if (error2 > -dy) {
				   error = error - dy;
				   x0 = x0 + x_step;
				 }
				 if (error2 < dx) {
				   error = error + dx;
				   y0 = y0 + y_step;
				 }
			}
		}
	}






	void draw_square(int frame_index, int x0, int y0, int x1, int y1)
	{
		draw_line(frame_index, x0, y0, x1, y0);
		draw_line(frame_index, x0, y0, x0, y1);
		draw_line(frame_index, x0, y1, x1, y1);
		draw_line(frame_index, x1, y0, x1, y1);
	}

	void draw_rectangular_align(int frame_index, int x0, int y0, int x1, int y1, int thickness)
	// The width of shape = thickness + 1
	// since the first and last point of the x-y sets are both included
	{
		for (int i =0; i<=thickness; i++) {
			draw_line(frame_index, x0+i, y0, x1+i, y1);
		}
	}



	void draw_test_pattern(int frame_index=0, int alpha=0x80)
	{
		const int pattern_width = (int)floor(width[frame_index]/3);
		const float color_delta = (float)0xFF / (float)pattern_width;

		float red = 0xFF;
		float green = 0;
		float blue = 0;
		int i;

		// Red-green pattern
		for (i=0; i<pattern_width; i++) {
			set_color((int)red, (int)green, (int)blue, alpha);
			draw_line(frame_index, i, 0, i, height[frame_index]) ;
			red -= color_delta;
			green += color_delta;
		}

		// Red-green pattern
		for (i=pattern_width; i<2*pattern_width; i++) {
			set_color((int)red, (int)green, (int)blue, alpha);
			draw_line(frame_index, i, 0, i, height[frame_index]) ;
			green -= color_delta;
			blue += color_delta;
		}

		// Red-green pattern
		for (i=2*pattern_width; i<3*pattern_width; i++) {
			set_color((int)red, (int)green, (int)blue, alpha);
			draw_line(frame_index, i, 0, i, height[frame_index]) ;
			blue -= color_delta;
			red += color_delta;
		}

		for (; i<width[frame_index]; i++)
			draw_line(frame_index, i, 0, i, height[frame_index]) ;
	}


	void draw_circle(int frame_index, int x0, int y0, int radius)
	// Draw circle using Bresenham's circle algorithm.
	{

	  int error = 1 - radius;
	  int dde_x = 1;
	  int dde_y = -2 * radius;
	  int x = 0;
	  int y = radius;

	  // top centre
	  set_pixel(frame_index, x0, y0 - radius);
	  // bottom centre
	  set_pixel(frame_index, x0, y0 + radius);
	  // right centre
	  set_pixel(frame_index, x0 + radius, y0);
	  // left centre
	  set_pixel(frame_index, x0 - radius, y0);

	  while(x < y)
	  {
		if(error >= 0)
		{
		  y--;
		  dde_y += 2;
		  error += dde_y;
		}
		x++;
		dde_x += 2;
		error += dde_x;

		// Fourth Quadrant
		set_pixel(frame_index, x0 + x, y0 + y);
		set_pixel(frame_index, x0 + y, y0 + x);

		// Third Quadrant
		set_pixel(frame_index, x0 - x, y0 + y);
		set_pixel(frame_index, x0 - y, y0 + x);

		// Second Quadrant
		set_pixel(frame_index, x0 - x, y0 - y);
		set_pixel(frame_index, x0 - y, y0 - x);

		// First Quadrant
		set_pixel(frame_index, x0 + y, y0 - x);
		set_pixel(frame_index, x0 + x, y0 - y);

	  }
	}



	void draw_arc(int frame_index, int x0, int y0, int radius, int angle_start, int angle_end)
	// Draw a segment of circle using Bresenham's circle algorithm.
	// The arc begin from the angle_start anti-clockwise toward the angle_end
	{
	  angle_start = angle_start % 360;
	  angle_end = angle_end % 360;

	  int error = 1 - radius;
	  int dde_x = 1;
	  int dde_y = -2 * radius;
	  int x = 0;
	  int y = radius;

	  /*
	   * int quad[8][3];
	   *
	   * [0]:assert if part of this quadrant contain the arc,
	   * [1][2]:x pos of the starting and end point in this quad
	   *
	   */
	  int quad[8][3];
	  int angular_length = (angle_end - angle_start + 360) % 360;

	  for (int i = 0; i<8; i++) {
		  int quad_angle_start = i*45;
		  int quad_angle_end = quad_angle_start + 45;

		  if ( delta_theta(angle_start, quad_angle_start) < angular_length  ||
				  is_between(angle_start, quad_angle_start, quad_angle_end) )  {
			  quad[i][0]=1;
			  quad_angle_start = is_between(angle_start, quad_angle_end, quad_angle_start)?angle_start:quad_angle_start;
			  quad_angle_end = is_between(angle_end, quad_angle_end, quad_angle_start)?angle_end:quad_angle_end;
			  quad[i][1]=abs((int)round(cos(float(quad_angle_start)*PI/180.0f)*float(radius)));
			  quad[i][2]=abs((int)round(cos(float(quad_angle_end)*PI/180.0f)*float(radius)));

		  } else {
			  quad[i][0]=0;
		  }
	  }

	  if (quad[1][0]&&quad[2][0]) set_pixel(frame_index, x0, y0 - radius);	// top centre
	  if (quad[5][0]&&quad[6][0]) set_pixel(frame_index, x0, y0 + radius);	// bottom centre
	  if (quad[7][0]&&quad[0][0]) set_pixel(frame_index, x0 + radius, y0);	// right centre
	  if (quad[3][0]&&quad[4][0]) set_pixel(frame_index, x0 - radius, y0);	// left centre


	  while(x < y)
	  {
		if(error >= 0)
		{
		  y--;
		  dde_y += 2;
		  error += dde_y;
		}
		x++;
		dde_x += 2;
		error += dde_x;

		// First Quadrant
		if ( (quad[0][0]==1) && is_between(y, quad[0][1], quad[0][2]) ) set_pixel(frame_index, x0 + y, y0 - x);
		if ( (quad[1][0]==1) && is_between(x, quad[1][1], quad[1][2]) ) set_pixel(frame_index, x0 + x, y0 - y);

		// Second Quadrant
		if ( (quad[2][0]==1) && is_between(x, quad[2][1], quad[2][2]) ) set_pixel(frame_index, x0 - x, y0 - y);
		if ( (quad[3][0]==1) && is_between(y, quad[3][1], quad[3][2]) ) set_pixel(frame_index, x0 - y, y0 - x);

		// Third Quadrant
		if ( (quad[4][0]==1) && is_between(y, quad[4][1], quad[4][2]) ) set_pixel(frame_index, x0 - y, y0 + x);
		if ( (quad[5][0]==1) && is_between(x, quad[5][1], quad[5][2]) ) set_pixel(frame_index, x0 - x, y0 + y);

		// Fourth Quadrant
		if ( (quad[6][0]==1) && is_between(x, quad[6][1], quad[6][2]) ) set_pixel(frame_index, x0 + x, y0 + y);
		if ( (quad[7][0]==1) && is_between(y, quad[7][1], quad[7][2]) ) set_pixel(frame_index, x0 + y, y0 + x);

	  }
	}


	int draw_text(int frame_index, const char str[], int x, int y, int size)
	{
		const float aspect = 2;		// ratio between height and width
		const float corner_ratio = 8;		// ratio between height and corner width/height
		const int th = size;
		const int tw = (int)round((float)size/aspect);
		const int offset = size / 4;
		const int crn = (int)floor((float)size / corner_ratio);
		const int su = max(1, (int)floor((float)size / corner_ratio));	// small unit, same as crn but has minimum value of 1

		int xp = x + offset;
		int yp = y + offset;

		char symbol;
		for (unsigned int i = 0; i < strlen(str); ++i) {
			symbol = str[i];

			switch (symbol){
				case '0':
					draw_square(frame_index, xp, yp, xp+tw, yp+th);
					break;
				case '1':
					draw_line(frame_index, xp, yp, xp+tw/2, yp);
					draw_line(frame_index, xp+tw/2, yp, xp+tw/2, yp+th);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					break;
				case '2':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp, yp+th);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					break;
				case '3':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th);
					break;
				case '4':
					draw_line(frame_index, xp, yp, xp, yp+th/2);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					break;
				case '5':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					draw_line(frame_index, xp, yp, xp, yp+th/2);
					draw_line(frame_index, xp+tw, yp+th/2, xp+tw, yp+th);
					break;
				case '6':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp+tw, yp+th/2, xp+tw, yp+th);
					break;
				case '7':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp, xp, yp+th/2);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th);
					break;
				case '8':
					draw_square(frame_index, xp, yp, xp+tw, yp+th);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					break;
				case '9':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					draw_line(frame_index, xp, yp, xp, yp+th/2);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th);
					break;
				case 'A':
				case 'a':
					draw_line(frame_index, xp, yp+crn, xp, yp+th);
					draw_line(frame_index, xp+tw, yp+crn, xp+tw, yp+th);
					draw_line(frame_index, xp, yp+crn, xp+crn, yp);
					draw_line(frame_index, xp+tw-crn, yp, xp+tw, yp+crn);
					draw_line(frame_index, xp+crn, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					break;
				case 'B':
				case 'b':
					draw_line(frame_index, xp, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th, xp+tw-crn, yp+th);
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp+tw-crn, yp, xp+tw, yp+crn);
					draw_line(frame_index, xp+tw, yp+crn, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp+th-crn, xp+tw-crn, yp+th);
					break;
				case 'C':
				case 'c':
					draw_line(frame_index, xp, yp+crn, xp+crn, yp);
					draw_line(frame_index, xp+crn, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp+crn, xp, yp+th-crn);
					draw_line(frame_index, xp, yp+th-crn, xp+crn, yp+th);
					draw_line(frame_index, xp+crn, yp+th, xp+tw, yp+th);
					break;
				case 'D':
				case 'd':
					draw_line(frame_index, xp, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp, yp+th, xp+tw-crn, yp+th);
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp+tw-crn, yp, xp+tw, yp+crn);
					draw_line(frame_index, xp+tw, yp+crn, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp+th-crn, xp+tw-crn, yp+th);
					break;
				case 'E':
				case 'e':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					draw_line(frame_index, xp, yp, xp, yp+th);
					break;
				case 'F':
				case 'f':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp, xp, yp+th);
					break;
				case 'G':
				case 'g':
					draw_line(frame_index, xp, yp+crn, xp+crn, yp);
					draw_line(frame_index, xp+crn, yp, xp+tw, yp);
					draw_line(frame_index, xp, yp+crn, xp, yp+th-crn);
					draw_line(frame_index, xp, yp+th-crn, xp+crn, yp+th);
					draw_line(frame_index, xp+crn, yp+th, xp+tw-crn, yp+th);
					draw_line(frame_index, xp+tw-crn, yp+th, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp+th-crn, xp+tw, yp+th/2);
					draw_line(frame_index, xp+tw/2, yp+th/2, xp+tw, yp+th/2);
					break;
				case 'H':
				case 'h':
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					break;
				case 'I':
				case 'i':
					draw_line(frame_index, xp+crn, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp+tw/2, yp, xp+tw/2, yp+th);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					break;
				case 'J':
				case 'j':
					draw_line(frame_index, xp, yp+th/2, xp, yp+th-crn);
					draw_line(frame_index, xp, yp+th-crn, xp+crn, yp+th);
					draw_line(frame_index, xp+crn, yp+th, xp+tw-crn, yp+th);
					draw_line(frame_index, xp+tw-crn, yp+th, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th-crn);
					break;
				case 'K':
				case 'k':
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp);
					draw_line(frame_index, xp, yp+th/2, xp+tw-crn, yp+th/2);
					draw_line(frame_index, xp+tw-crn, yp+th/2, xp+tw, yp+th/2+crn);
					draw_line(frame_index, xp+tw, yp+th/2+crn, xp+tw, yp+th);
					break;
				case 'L':
				case 'l':
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					break;
				case 'M':
				case 'm':
					draw_line(frame_index, xp, yp+crn, xp, yp+th);
					draw_line(frame_index, xp+tw, yp+crn, xp+tw, yp+th);
					draw_line(frame_index, xp, yp+crn, xp+crn, yp);
					draw_line(frame_index, xp+tw-crn, yp, xp+tw, yp+crn);
					draw_line(frame_index, xp+crn, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp+tw/2, yp, xp+tw/2, yp-crn+th/2);
					break;
				case 'N':
				case 'n':
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th);
					draw_line(frame_index, xp, yp+crn, xp+tw, yp+th/2-crn);
					break;
				case 'O':
				case 'o':
					draw_line(frame_index, xp, yp+crn, xp+crn, yp);
					draw_line(frame_index, xp+crn, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp+tw-crn, yp, xp+tw, yp+crn);
					draw_line(frame_index, xp+tw, yp+crn, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp+th-crn, xp+tw-crn, yp+th);
					draw_line(frame_index, xp+tw-crn, yp+th, xp+crn, yp+th);
					draw_line(frame_index, xp+crn, yp+th, xp, yp+th-crn);
					draw_line(frame_index, xp, yp+th-crn, xp, yp+crn);
					break;
				case 'P':
				case 'p':
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp+tw-crn, yp, xp+tw, yp+crn);
					draw_line(frame_index, xp+tw, yp+crn, xp+tw, yp+th/2-crn);
					draw_line(frame_index, xp+tw, yp+th/2-crn, xp+tw-crn, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw-crn, yp+th/2);
					break;
				case 'Q':
				case 'q':
					draw_line(frame_index, xp, yp+crn, xp+crn, yp);
					draw_line(frame_index, xp+crn, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp+tw-crn, yp, xp+tw, yp+crn);
					draw_line(frame_index, xp+tw, yp+crn, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp+th-crn, xp+tw-crn, yp+th);
					draw_line(frame_index, xp+tw-crn, yp+th, xp+crn, yp+th);
					draw_line(frame_index, xp+crn, yp+th, xp, yp+th-crn);
					draw_line(frame_index, xp, yp+th-crn, xp, yp+crn);
					draw_line(frame_index, xp+tw/2, yp+th-tw/2, xp+tw, yp+th);
					break;
				case 'R':
				case 'r':
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp, yp, xp+tw-crn, yp);
					draw_line(frame_index, xp+tw-crn, yp, xp+tw, yp+crn);
					draw_line(frame_index, xp+tw, yp+crn, xp+tw, yp+th/2-crn);
					draw_line(frame_index, xp+tw, yp+th/2-crn, xp+tw-crn, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw-crn, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th);
					break;
				case 'S':
				case 's':
					draw_line(frame_index, xp+tw, yp, xp+crn, yp);
					draw_line(frame_index, xp+crn, yp, xp, yp+crn);
					draw_line(frame_index, xp, yp+crn, xp, yp+th/2-crn);
					draw_line(frame_index, xp, yp+th/2-crn, xp+crn, yp+th/2);
					draw_line(frame_index, xp+crn, yp+th/2, xp+tw-crn, yp+th/2);
					draw_line(frame_index, xp+tw-crn, yp+th/2, xp+tw, yp+th/2+crn);
					draw_line(frame_index, xp+tw, yp+th/2+crn, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp+th-crn, xp+tw-crn, yp+th);
					draw_line(frame_index, xp+tw-crn, yp+th, xp, yp+th);
					break;
				case 'T':
				case 't':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp+tw/2, yp, xp+tw/2, yp+th);
					break;
				case 'U':
				case 'u':
					draw_line(frame_index, xp, yp, xp, yp+th-crn);
					draw_line(frame_index, xp, yp+th-crn, xp+crn, yp+th);
					draw_line(frame_index, xp+crn, yp+th, xp+tw-crn, yp+th);
					draw_line(frame_index, xp+tw-crn, yp+th, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th-crn);
					break;
				case 'V':
				case 'v':
					draw_line(frame_index, xp, yp, xp, yp+th/2);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw/2, yp+th);
					draw_line(frame_index, xp+tw, yp+th/2, xp+tw/2, yp+th);
					break;
				case 'W':
				case 'w':
					draw_line(frame_index, xp, yp, xp, yp+th-crn);
					draw_line(frame_index, xp, yp+th-crn, xp+crn, yp+th);
					draw_line(frame_index, xp+crn, yp+th, xp+tw-crn, yp+th);
					draw_line(frame_index, xp+tw-crn, yp+th, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th-crn);
					draw_line(frame_index, xp+tw/2, yp+th, xp+tw/2, yp+th/2+crn);
					break;
				case 'X':
				case 'x':
					draw_line(frame_index, xp, yp, xp+tw, yp+th);
					draw_line(frame_index, xp+tw, yp, xp, yp+th);
					break;
				case 'Y':
				case 'y':
					draw_line(frame_index, xp, yp, xp, yp+th/2);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					break;
				case 'Z':
				case 'z':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp+tw, yp, xp, yp+th);
					draw_line(frame_index, xp, yp+th, xp+tw, yp+th);
					break;
				case '%':
					draw_line(frame_index, xp+tw, yp, xp, yp+th);
					draw_square(frame_index, xp, yp, xp+tw/2, yp+tw/2);
					draw_square(frame_index, xp+tw/2, yp+th-tw/2, xp+tw, yp+th);
					break;
				case '=':
					draw_line(frame_index, xp, yp+th/2-tw/2+crn, xp+tw, yp+th/2-tw/2+crn);
					draw_line(frame_index, xp, yp+th/2+tw/2-crn, xp+tw, yp+th/2+tw/2-crn);
					break;
				case '+':
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp+tw/2, yp+th/2-tw/2, xp+tw/2, yp+th/2+tw/2);
					break;
				case '-':
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					break;
				case '*':
					draw_line(frame_index, xp+tw/2, yp+th/2-tw/2, xp+tw/2, yp+th/2+tw/2);
					draw_line(frame_index, xp, yp+th/2-tw/2, xp+tw, yp+th/2+tw/2);
					draw_line(frame_index, xp+tw, yp+th/2-tw/2, xp, yp+th/2+tw/2);
					break;
				case '/':
					draw_line(frame_index, xp+tw, yp, xp, yp+th);
					break;
				case '\\':
					draw_line(frame_index, xp, yp, xp+tw, yp+th);
					break;
				case '.':
					draw_rectangular_align(frame_index, xp, yp+th-su, xp, yp+th, su);
					xp -= (offset+su);
					break;
				case '<':
					draw_line(frame_index, xp+tw, yp, xp, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th);
					break;
				case '>':
					draw_line(frame_index, xp, yp, xp+tw, yp+th/2);
					draw_line(frame_index, xp+tw, yp+th/2, xp, yp+th);
					break;
				case '(':
					draw_line(frame_index, xp, yp+crn, xp+crn, yp);
					draw_line(frame_index, xp+crn, yp, xp+tw/2, yp);
					draw_line(frame_index, xp, yp+crn, xp, yp+th-crn);
					draw_line(frame_index, xp, yp+th-crn, xp+crn, yp+th);
					draw_line(frame_index, xp+crn, yp+th, xp+tw/2, yp+th);
					xp -= offset;
					break;
				case ')':
					draw_line(frame_index, xp, yp, xp+tw/2-crn, yp);
					draw_line(frame_index, xp, yp+th, xp+tw/2-crn, yp+th);
					draw_line(frame_index, xp+tw/2-crn, yp, xp+tw/2, yp+crn);
					draw_line(frame_index, xp+tw/2, yp+crn, xp+tw/2, yp+th-crn);
					draw_line(frame_index, xp+tw/2, yp+th-crn, xp+tw/2-crn, yp+th);
					xp -= offset;
					break;
				case '[':
					draw_line(frame_index, xp, yp, xp, yp+th);
					draw_line(frame_index, xp, yp, xp+tw/2, yp);
					draw_line(frame_index, xp, yp+th, xp+tw/2, yp+th);
					xp -= offset;
					break;
				case ']':
					draw_line(frame_index, xp+tw/2, yp, xp+tw/2, yp+th);
					draw_line(frame_index, xp, yp, xp+tw/2, yp);
					draw_line(frame_index, xp, yp+th, xp+tw/2, yp+th);
					xp -= offset;
					break;
				case ':':
					draw_rectangular_align(frame_index, xp, yp+tw/2-su, xp, yp+tw/2, su);
					draw_rectangular_align(frame_index, xp, yp+th-tw/2, xp, yp+th-tw/2+su, su);
					xp -= (offset+su);
					break;
				case '?':
					draw_line(frame_index, xp, yp, xp+tw, yp);
					draw_line(frame_index, xp+tw, yp, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp+tw, yp+th/2);
					draw_line(frame_index, xp, yp+th/2, xp, yp+th-tw/2);
					draw_rectangular_align(frame_index, xp, yp+th-su, xp, yp+th, 1);
					break;
				case '!':
					draw_line(frame_index, xp, yp, xp, yp+th-tw/2);
					draw_rectangular_align(frame_index, xp, yp+th-su, xp, yp+th, 1);
					xp -= 2*offset;
					break;
				case '\'':
					draw_line(frame_index, xp, yp, xp, yp+tw/2);
					xp -= 2*offset;
					break;
				case '"':
					draw_line(frame_index, xp, yp, xp, yp+tw/2);
					draw_line(frame_index, xp+tw/2-su, yp, xp+tw/2-su, yp+tw/2);
					xp -= (offset+su);
					break;
				case '|':
					draw_line(frame_index, xp, yp, xp, yp+th);
					xp -= 2*offset;
					break;
				case ',':
					draw_line(frame_index, xp, yp+th-tw/2, xp, yp+th);
					xp -= 2*offset;
					break;
				case '#':
					draw_line(frame_index, xp, yp+th/2-su, xp+tw, yp+th/2-su);
					draw_line(frame_index, xp, yp+th/2+su, xp+tw, yp+th/2+su);
					draw_line(frame_index, xp+tw/2-su, yp+th/2-tw/2, xp+tw/2-su, yp+th/2+tw/2);
					draw_line(frame_index, xp+tw/2+su, yp+th/2-tw/2, xp+tw/2+su, yp+th/2+tw/2);
					break;

				case ' ':
					// Space, do nothing
					break;
				default :
					//printf("this is something else : [%c]\n", symbol);
					draw_square(frame_index, xp-offset, yp-offset, xp+tw+offset, yp+th+offset);
					break;
			}

			xp += (offset<<1) + tw;

		}

		return xp;

	}




	/*********************************************************
	 *
	 * Screen map function
	 *
	 * Screen map is a list of each line on the screen, storing only the starting and end
	 * node of any shape added into the list. It is suitable for drawing solid shape, including
	 * square, rectangular, circle arc and other non-standard shape. Single border shape is
	 * also support but may not be as efficient as direct drawing.
	 *
	 * During initialisation, the list is created with a header node for each line (further
	 * improvement of memory usage can be done here by using list without header / without
	 * full header).
	 *
	 * Any shapes added using the draw_***_sm function is interpreted as Left && Right node pair
	 * store in the screen map list. Inverse shape (remove a partition area from the existing
	 * shape) is therefore done by inserting Right && Left pair in reverse order. Non-pair drawing
	 * (shape without both left and right border) can also be added using brd_single option.
	 *
	 * The shape added stored only in the list, and haven't been written to the memory. Call
	 * draw_screen_map(int frame_index) function to write the screen map to certain frame. And
	 * then use clear_screen_map() function to release memory.
	 *
	 *
	 * ============== Warning ===============
	 * The screen map function are not fully tested. To keep the full flexibility that a user may need,
	 * leave a few known constrains and some undefined problems as well.
	 *
	 *
	 * The main problem comes from circle and arc drawing. When the gradient is small, it will produce
	 * multiple x values for one y value (or vice versa). Thus the algorithm is likely to create some
	 * non-paired left and right nodes, which leads the validation algorithm to miss-judge the correct
	 * edge. This is currently compensated by adding one extra boolean variable "clean" to the node
	 * prototype, and running a remove duplication process after inserting any circle or arc shapes.
	 * This will reduce efficiency and also increase memory usage. And furthermore, when there is
	 * another shape inserted before the circle, which has not been validated, is likely to mix with
	 * the circle's validation process, leading to an unexpected shape. This should be further improved
	 * by either rewriting the circle algorithm and the remove duplication process, or re-defining the
	 * border property type.
	 *
	 * Different shape colors are currently interpreted separately, which reduces efficiency as well.
	 * In order to combine different shape colors into one shape, the logic of the validation function
	 * should be redesigned . Further improvements can also be done by interpreting the color linearly
	 * between two borders, so that a color gradient can also be defined and drawn.
	 *
	 * Memory usage is another constraint. When using a screen map to draw large or multiple shapes,
	 * especially with a long vertical length, memory will be used up very quickly. Excessive usage of
	 * memory may result in the NIOS process continuously resetting (this depend on the system setting),
	 * or conflicts with other buffers stored in the memory. Considering on-device memory resource is a
	 * tight limit on FPGA devices, it is advised to use other memory resources such as SRAM or DDR
	 * memory for the heap space of the NIOS processor. Always try to keep the drawing areas small, and
	 * release memory when possible.
	 *
	 ********************************************************/

	void draw_screen_map(int frame_index) {
		horiz_node* current_node;

		validate_screen_map();

		// begin drawing
		for (int n=0; n<screen_map_height; n++) {
			current_node = screen_map[n].next;
			while (current_node!= NULL){
				if (current_node->border_property==brd_single) {
					set_pixel_sm(frame_index, current_node->x, n, current_node->color);
				} else {
					int x0 = current_node->x;
					current_node = current_node->next;
					int x1 = (current_node==NULL)?screen_map_width-1:current_node->x;

					for (int k=x0; k<=x1; k++) {
						set_pixel_sm(frame_index, k, n, current_node->color);
					}
				}
				current_node = current_node->next;
			}
		}
	}

	void validate_screen_map(){

		horiz_node* pre_node;
		horiz_node* current_node;

		//make each line clear and valid
		for (int i=0; i<screen_map_height; i++) {
			pre_node = screen_map+i;
			current_node = pre_node->next;
			int outstanding_edge = 0;

			while (current_node!=NULL){
				// Find the left edge and search for the next valid right node for pairing
				switch (current_node->border_property) {

					case brd_left:

						if (outstanding_edge>0) {
							outstanding_edge -= 1;
							current_node = pre_node;
							delete_node(pre_node);
							break;
						}

						pre_node = current_node;
						current_node = current_node->next;

						while (current_node!=NULL){
							if (current_node->border_property==brd_right) {
								if (outstanding_edge == 0){
									break;
								} else {
									current_node = pre_node;
									outstanding_edge -= 1;
									delete_node(pre_node);
								}
							} else {
								if (current_node->border_property==brd_left) {
									outstanding_edge += 1;
								} // else node is single or invalid
								current_node = pre_node;
								delete_node(pre_node);
							}
							pre_node = current_node;
							current_node = current_node->next;
						}
						break;
					case brd_right:
						current_node = pre_node;
						outstanding_edge += 1;
						delete_node(pre_node);
						break;
					case brd_single:
						// do nothing, the single point is not effected by inverse mask
						break;
					default:
						current_node = pre_node;
						delete_node(pre_node);
						break;
				} // finish pairing two nodes

				pre_node = current_node;
				current_node = current_node->next;
			}
		}

	}


	// for use in drawing circle and line with duplicated data only
	void remove_duplicated_screen_map(int y0, int y1)		// range
	{
		horiz_node* pre_node;
		horiz_node* current_node;
		horiz_node* next_node;

		for (int i=min(y0, y1); i<=min(max(y0, y1), screen_map_height-1); i++){
			pre_node = &screen_map[i];
			current_node = pre_node->next;

			while (current_node!=NULL){
				next_node = current_node->next;
				if (!current_node->is_clean && !next_node->is_clean &&
						next_node->border_property==current_node->border_property &&
						next_node->color == current_node->color) {
					if (current_node->border_property == brd_left) {
						delete_node(current_node);
					} else {
						if (current_node->border_property == brd_right) {
							current_node = current_node->next;
							delete_node(pre_node);
						} else {
							pre_node = current_node;
							current_node = current_node->next;
						}
					}
				} else {
					current_node->is_clean = true;
					pre_node = current_node;
					current_node = current_node->next;
				}
			}
		}
	}


	void clear_screen_map()
	{
		horiz_node* current_node;
		horiz_node* tmp_node;
		for (int i=0; i<screen_map_height; i++) {
			current_node = screen_map[i].next;
			while (current_node != NULL){
				tmp_node = current_node;
				current_node = current_node->next;
				delete tmp_node;
			}
			screen_map[i].next = NULL;
		}
	}

	void release_screen_map()
	{
		clear_screen_map();
		delete screen_map;
	}


	void print_screen_map()
	{
		printf("\n\n=======================================================\n");
		for (int i=0; i<screen_map_height; i++) {
			horiz_node* current_node = screen_map[i].next;
			if (current_node!=NULL) printf("\nLine[%d@%d] -> ", i, (int)current_node);
			while (current_node != NULL){
				printf("x=%d brd=%d | ", current_node->x, current_node->border_property);
				current_node = current_node->next;
			}
		}
		printf("\n=======================================================\n\n");
	}


	
	void set_pixel_sm(int frame_index, int x, int y, int pixel_color=-1)
	{
		x += screen_map_xoffset;
		y += screen_map_yoffset;
		if ( (x>=0 && x< width[frame_index]) && (y>=0 && y< height[frame_index]) )
			IOWR(this->frame_addr[frame_index], (x+y*width[frame_index]), (pixel_color<0)?color:pixel_color);
	}



	void draw_line_sm(int x0, int y0, int x1, int y1) {
		draw_line_bresenham(x0, y0, x1, y1, brd_single);
	}


	void draw_line_bresenham(int x0, int y0, int x1, int y1, int border_property) {
		if (y0 == y1) {
			insert_node((x1>x0)?x0:x1, y0, brd_left);
			insert_node((x1>x0)?x1:x0, y1, brd_right);
		} else if (x0==x1) {
			for (int i=min(y0, y1); i<=max(y0, y1); i++){
				insert_node(x0, i, border_property);
			}
		} else {
			int dx = (int)abs(x1-x0);
			int dy = (int)abs(y1-y0);
			int x_step, y_step, error, error2;
			if (x0 < x1)
				x_step = 1;
			else
				x_step = -1;

			if (y0 < y1)
				y_step = 1;
			else
				y_step = -1;

			error = dx - dy;

			while(true) {
				 //set_pixel(frame_index, x0, y0);
				insert_node(x0, y0, border_property);
				if (x0==x1 && y0==y1) break;
				error2 = error << 1;
				if (error2 > -dy) {
					error = error - dy;
					x0 = x0 + x_step;
				}
				if (error2 < dx) {
					error = error + dx;
					y0 = y0 + y_step;
				}
			}

		}

	}


	void draw_square_sm(int x0, int y0, int x1, int y1, int invert=0)
	{
		int left_edge, right_edge;
		if (invert==2) {
			right_edge = brd_single;
			left_edge = brd_single;
		} else if (invert == 1){
			right_edge = brd_left;
			left_edge = brd_right;
		} else {
		  	right_edge = brd_right;
		  	left_edge = brd_left;
		}

		draw_line_bresenham(x0, y0, x0, y1, left_edge);
		draw_line_bresenham(x1, y0, x1, y1, right_edge);
	}




	void draw_border_sm(int border_width=1)
	{
		int max_bw = min((int)floor(screen_map_width/2), (int)floor(screen_map_height/2));
		int bw = (int)round(max(0, min(max_bw, border_width)));

		draw_square_sm(0,0,screen_map_width-1, screen_map_height-1);
		draw_square_sm(bw,bw,screen_map_width-1-bw, screen_map_height-1-bw, true);

	}



	void draw_circle_sm(int x0, int y0, int radius, int invert=0)
		// Draw circle using Bresenham's circle algorithm.
	{

	  int error = 1 - radius;
	  int dde_x = 1;
	  int dde_y = -2 * radius;
	  int x = 0;
	  int y = radius;
	  int left_edge, right_edge;

	  if (invert==2) {
		  right_edge = brd_single;
		  left_edge = brd_single;
	  } else if (invert == 1){
		  right_edge = brd_left;
		  left_edge = brd_right;
	  } else {
		  right_edge = brd_right;
		  left_edge = brd_left;
	  }

	  if (invert) {
		  // top centre
		  insert_node(x0, y0 - radius, brd_right);
		  insert_node(x0, y0 - radius, brd_left);
		  // bottom centre
		  insert_node(x0, y0 + radius, brd_right);
		  insert_node(x0, y0 + radius, brd_left);
	  } else {
		  // top centre
		  insert_node(x0, y0 - radius, brd_single);
		  // bottom centre
		  insert_node(x0, y0 + radius, brd_single);
	  }
	  // right centre
	  insert_node(x0 + radius, y0, right_edge);
	  // left centre
	  insert_node(x0 - radius, y0, left_edge);



	  while(x < y)
	  {
		if(error >= 0)
		{
		  y--;
		  dde_y += 2;
		  error += dde_y;
		}
		x++;
		dde_x += 2;
		error += dde_x;

		// Fourth Quadrant
		insert_node(x0 + x, y0 + y, right_edge);
		insert_node(x0 + y, y0 + x, right_edge);

		// Third Quadrant
		insert_node(x0 - x, y0 + y, left_edge);
		insert_node(x0 - y, y0 + x, left_edge);

		// Second Quadrant
		insert_node(x0 - x, y0 - y, left_edge);
		insert_node(x0 - y, y0 - x, left_edge);

		// First Quadrant
		insert_node(x0 + y, y0 - x, right_edge);
		insert_node(x0 + x, y0 - y, right_edge);


	  }

	  remove_duplicated_screen_map(y0-radius, y0+radius);
	}



	void draw_ring_sm(int x0, int y0, int radius0, int radius1){
		if (radius0 != radius1) {
			draw_circle_sm(x0, y0, (radius0>radius1)?radius0:radius1);
			draw_circle_sm(x0, y0, (radius0>radius1)?radius1:radius0, true);
		}
	}






	void draw_arc_sm(int x0, int y0, int radius, int angle_start, int angle_end, int invert=false)
	// Draw a segment of solid circle using Bresenham's circle algorithm.
	// The arc begin from the angle_start anti-clockwise toward the angle_end
	{

	  int left_edge, right_edge;

	  if (invert==2) {
	  	right_edge = brd_single;
	  	left_edge = brd_single;
	  } else if (invert == 1){
	  	right_edge = brd_left;
	  	left_edge = brd_right;
	  } else {
	  	right_edge = brd_right;
	  	left_edge = brd_left;
	  }

	  angle_start = angle_start % 360;
	  angle_end = angle_end % 360;

	  int error = 1 - radius;
	  int dde_x = 1;
	  int dde_y = -2 * radius;
	  int x = 0;
	  int y = radius;

	  /* int quad[8][3];
	   * [0]:assert if part of this quadrant contain the arc,
	   * [1][2]:x pos of the starting and end point in this quad
	   */
	  int quad[8][3];
	  int angular_length = (angle_end - angle_start + 360) % 360;

	  for (int i = 0; i<8; i++) {
		  int quad_angle_start = i*45;
		  int quad_angle_end = quad_angle_start + 45;

		  if ( delta_theta(angle_start, quad_angle_start) < angular_length  ||
				  is_between(angle_start, quad_angle_start, quad_angle_end) )  {
			  quad[i][0]=1;
		  	  quad_angle_start = is_between(angle_start, quad_angle_end, quad_angle_start)?angle_start:quad_angle_start;
			  quad_angle_end = is_between(angle_end, quad_angle_end, quad_angle_start)?angle_end:quad_angle_end;
			  quad[i][1]=abs((int)round(cos(float(quad_angle_start)*PI/180.0f)*float(radius)));
			  quad[i][2]=abs((int)round(cos(float(quad_angle_end)*PI/180.0f)*float(radius)));
		  } else {
			  quad[i][0]=0;
		  }
	  }

	  if (invert) {
		  // top centre
		  if (quad[1][0]&&quad[2][0]) {
			  insert_node(x0, y0 - radius, brd_right);
			  insert_node(x0, y0 - radius, brd_left);
		  }
		  // bottom centre
		  if (quad[5][0]&&quad[6][0]) {
			  insert_node(x0, y0 + radius, brd_right);
			  insert_node(x0, y0 + radius, brd_left);
		  }
	  } else {
		  // top centre
		  if (quad[1][0]&&quad[2][0]) insert_node(x0, y0 - radius, brd_single);
		  // bottom centre
		  if (quad[5][0]&&quad[6][0]) insert_node(x0, y0 + radius, brd_single);
	  }
	  // right centre
	  if (quad[7][0]&&quad[0][0]) insert_node(x0 + radius, y0, right_edge);
	  // left centre
	  if (quad[3][0]&&quad[4][0]) insert_node(x0 - radius, y0, left_edge);


	  while(x < y)
	  {
	    if(error >= 0)
	    {
	      y--;
	      dde_y += 2;
	      error += dde_y;
	    }
	    x++;
	    dde_x += 2;
	    error += dde_x;

	    // First Quadrant
	    if ( (quad[0][0]==1) && is_between(y, quad[0][1], quad[0][2]) ) insert_node(x0 + y, y0 - x, right_edge);
	    if ( (quad[1][0]==1) && is_between(x, quad[1][1], quad[1][2]) ) insert_node(x0 + x, y0 - y, right_edge);

	    // Second Quadrant
		if ( (quad[2][0]==1) && is_between(x, quad[2][1], quad[2][2]) ) insert_node(x0 - x, y0 - y, left_edge);
		if ( (quad[3][0]==1) && is_between(y, quad[3][1], quad[3][2]) ) insert_node(x0 - y, y0 - x, left_edge);

		// Third Quadrant
		if ( (quad[4][0]==1) && is_between(y, quad[4][1], quad[4][2]) ) insert_node(x0 - y, y0 + x, left_edge);
		if ( (quad[5][0]==1) && is_between(x, quad[5][1], quad[5][2]) ) insert_node(x0 - x, y0 + y, left_edge);

	    // Fourth Quadrant
	    if ( (quad[6][0]==1) && is_between(x, quad[6][1], quad[6][2]) ) insert_node(x0 + x, y0 + y, right_edge);
	    if ( (quad[7][0]==1) && is_between(y, quad[7][1], quad[7][2]) ) insert_node(x0 + y, y0 + x, right_edge);

	  }


	  int start_coord_x = (int)round(cos(float(angle_start)*PI/180.0f)*float(radius));
	  int start_coord_y = (int)round(sin(float(angle_start)*PI/180.0f)*float(radius));
	  int end_coord_x = (int)round(cos(float(angle_end)*PI/180.0f)*float(radius));
	  int end_coord_y = (int)round(sin(float(angle_end)*PI/180.0f)*float(radius));

	  if (start_coord_y < 0) {
		  draw_line_bresenham(x0, y0, x0+start_coord_x, y0-start_coord_y, left_edge);
		  insert_node(x0, y0, right_edge);
	  } else {
		  insert_node(x0, y0, left_edge);
		  draw_line_bresenham(x0, y0, x0+start_coord_x, y0-start_coord_y, right_edge);
	  }

	  if (end_coord_y < 0) {
		  insert_node(x0, y0, left_edge);
		  draw_line_bresenham(x0, y0, x0+end_coord_x, y0-end_coord_y, right_edge);

	  } else {
		  draw_line_bresenham(x0, y0, x0+end_coord_x, y0-end_coord_y, left_edge);
		  insert_node(x0, y0, right_edge);
	  }

	  //print_screen_map();
	  remove_duplicated_screen_map(y0-radius, y0+radius);

	}

};


#endif  // __SCREEN_DISPLAY_HPP__



