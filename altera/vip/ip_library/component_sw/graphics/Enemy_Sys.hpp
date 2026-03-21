#ifndef __ENEMY_SYS_HPP_
#define __ENEMY_SYS_HPP_

#include "Screen_Display.hpp"

#include <stdlib.h>

#define motion_angle_variation 40
#define enemy_size 2
#define speed_line_ratio 128
#define edge_margin 8
#define info_panel_length_s 25
#define info_panel_length_h 80

// color 0xRRGGBBAA


class Enemy_Sys{
private:

	struct Enemy {
		float x;
		float y;
		float x_pre;
		float y_pre;
		float dx;
		float dy;
		float angle;
		float speed;
		int life;
		unsigned int color_a;
		unsigned int color_b;
		unsigned int color_g;
		unsigned int color_r;
		bool is_drawn;
		bool is_dead;
		Enemy* next;
	};

	int x0, y0;
	float max_speed;
	float min_speed;
	int life_increment;
	int max_distance;
	int enemy_num;
	int amp_ratio;
	unsigned int color_a_hl;
	unsigned int color_b_hl;
	unsigned int color_g_hl;
	unsigned int color_r_hl;
	unsigned int color_a_dim;
	unsigned int color_b_dim;
	unsigned int color_g_dim;
	unsigned int color_r_dim;
	int r_step;
	int g_step;
	int b_step;
	int a_step;
	Screen_Display* screen_writer;
	Enemy* list_header;


	void insert_enemy(float x, float y, float dx, float dy, float angle, float speed,
			unsigned int color_a, unsigned int color_b, unsigned int color_g, unsigned int color_r, int life)
	{
		Enemy* tmp_node = list_header;
		while (tmp_node->next!=NULL) {
			tmp_node = tmp_node->next;
		}

		enemy_num += 1;

		tmp_node->next = new Enemy;
		tmp_node = tmp_node->next;
		tmp_node->x = x;
		tmp_node->y = y;
		tmp_node->x_pre = x;
		tmp_node->x_pre = y;
		tmp_node->dx = dx;
		tmp_node->dy = dy;
		tmp_node->life = life;
		tmp_node->color_a = color_a;
		tmp_node->color_b = color_b;
		tmp_node->color_g = color_g;
		tmp_node->color_r = color_r;
		tmp_node->next = NULL;
		tmp_node->angle = angle;
		tmp_node->is_drawn = false;
		tmp_node->is_dead =false;
		tmp_node->speed = speed;

	}


	void delete_enemy(Enemy* pre_enemy, int current_frame=-1)
	{

		enemy_num -= 1;
		if (pre_enemy->next != NULL) {
			Enemy* tmp_node = pre_enemy->next;
			//printf("deleteing node: %d -> %d -> %d\n", (int)pre_enemy,(int)pre_enemy->next, (int)pre_enemy->next->next);
			if (current_frame>=0)
				plot_node(pre_enemy->next, (current_frame)?0:1, true);
			pre_enemy->next = pre_enemy->next->next;
			delete tmp_node;
		}

	}


	void clear_enemy()
	{
		Enemy* tmp_enemy = list_header;
		Enemy* current_enemy = list_header->next;

		while (current_enemy != NULL) {
			tmp_enemy = current_enemy;
			current_enemy = current_enemy->next;
			delete tmp_enemy;
		}
		enemy_num = 0;
	}

public:
	Enemy_Sys(Screen_Display* the_screen_writer, int centre_x, int centre_y){
		screen_writer = the_screen_writer;
		x0 = centre_x;
		y0 = centre_y;

		list_header = new Enemy;
		list_header->next = NULL;
		enemy_num = 0;

	}

	~Enemy_Sys(){
		clear_enemy();
		delete list_header;
	}

	void init_enemy_sys(int max_distance_from_center, float enemy_min_speed, float enemy_max_speed, int reflash_life_increment, unsigned int highlight_color, unsigned int dim_color, int color_step_num)
	{
		max_distance = (int)pow(max_distance_from_center-edge_margin,2);
		max_speed = enemy_max_speed;
		min_speed = enemy_min_speed;
		life_increment = reflash_life_increment;
		color_r_hl = (highlight_color & 0xFF000000) >> 24;
		color_g_hl = (highlight_color & 0x00FF0000) >> 16;
		color_b_hl = (highlight_color & 0x0000FF00) >> 8;
		color_a_hl = (highlight_color & 0x000000FF);
		color_r_dim = (dim_color & 0xFF000000) >> 24;
		color_g_dim = (dim_color & 0x00FF0000) >> 16;
		color_b_dim = (dim_color & 0x0000FF00) >> 8;
		color_a_dim = (dim_color & 0x000000FF);

		a_step = floor((float(color_a_dim) - float(color_a_hl)) / float(color_step_num));
		b_step = floor((float(color_b_dim) - float(color_b_hl)) / float(color_step_num));
		g_step = floor((float(color_g_dim) - float(color_g_hl)) / float(color_step_num));
		r_step = floor((float(color_r_dim) - float(color_r_hl)) / float(color_step_num));
	}


	void create_enemy(int x, int y, int angle, int init_life)
	{
		float speed = min_speed + ((float)(rand() % 65535) / 65535.0f)*(max_speed-min_speed);
		float motion_angle = angle + (rand() % motion_angle_variation);
		float dx = -speed*cos((float)motion_angle*PI/180);
		float dy = -speed*sin((float)motion_angle*PI/180);
		insert_enemy(x, y, dx, dy, angle, speed, color_a_dim, color_b_dim, color_g_dim, color_r_dim, init_life);
	}



	void refresh_enemy(int current_frame, int angle) {

		plot_list(current_frame, true);
		remove_dead_enemy();

		int scan_section = angle / 45;
		int enemy_section = 0;

		Enemy* tmp_node = list_header->next;

		while (tmp_node!=NULL) {
			// update position
			tmp_node->x_pre = tmp_node->x;
			tmp_node->y_pre = tmp_node->y;
			tmp_node->x += tmp_node->dx;
			tmp_node->y += tmp_node->dy;
			tmp_node->life -= 1;

			if (tmp_node->life%2 == 0) {
				if ( ((a_step < 0) && ((int(tmp_node->color_a) + a_step) > int(color_a_dim))) ||
					 ((a_step > 0) && ((int(tmp_node->color_a) + a_step) < int(color_a_dim))) ) {
					tmp_node->color_a += a_step;
				} else  {
					tmp_node->color_a = color_a_dim;
				}
				if ( ((r_step < 0) && ((int(tmp_node->color_r) + r_step) > int(color_r_dim))) ||
					 ((r_step > 0) && ((int(tmp_node->color_r) + r_step) < int(color_r_dim))) ) {
					tmp_node->color_r += r_step;
				} else  {
					tmp_node->color_r = color_r_dim;
				}
				if ( ((g_step < 0) && ((int(tmp_node->color_g) + g_step) > int(color_g_dim))) ||
					 ((g_step > 0) && ((int(tmp_node->color_g) + g_step) < int(color_g_dim))) ) {
					tmp_node->color_g += g_step;
				} else  {
					tmp_node->color_g = color_g_dim;
				}
				if ( ((b_step < 0) && ((int(tmp_node->color_b) + b_step) > int(color_b_dim))) ||
					 ((b_step > 0) && ((int(tmp_node->color_b) + b_step) < int(color_b_dim))) ) {
					tmp_node->color_b += b_step;
				} else  {
					tmp_node->color_b = color_b_dim;
				}
			}


			tmp_node->angle = ((float)atan2(tmp_node->y,tmp_node->x)*(float)180/PI);
			tmp_node->angle = (tmp_node->angle<0)? tmp_node->angle + 360 : tmp_node->angle;
			enemy_section = (int)tmp_node->angle / 45;

			if (enemy_section == scan_section) {
				// update life and color
				if (angle < tmp_node->angle) {
					tmp_node->color_a = color_a_hl;
					tmp_node->color_r = color_r_hl;
					tmp_node->color_g = color_g_hl;
					tmp_node->color_b = color_b_hl;
					tmp_node->life += life_increment;
				}
			}

			if (tmp_node->life < 0 || max_distance<(pow(tmp_node->x,2)+pow(tmp_node->y,2))) {
				tmp_node->is_dead = true;
			}

			tmp_node = tmp_node->next;
		}

		plot_list(current_frame, false);

	}


	void remove_dead_enemy(){
		Enemy* tmp_node = list_header->next;
		Enemy* pre_node = list_header;
		while (tmp_node!=NULL) {
			if (tmp_node->is_dead) {
				tmp_node = tmp_node->next;
				delete_enemy(pre_node);
			} else {
				pre_node = tmp_node;
				tmp_node = tmp_node->next;
			}
		}
	}

	void plot_list(int current_frame, bool is_remove)
	{
		Enemy* tmp_node = list_header->next;
		while (tmp_node!=NULL) {
			if ((!tmp_node->is_dead) || is_remove) {
				plot_node(tmp_node, current_frame, is_remove);
			}
			tmp_node = tmp_node->next;
		}
	}




	void plot_node(Enemy* plot_node, int current_frame, bool is_remove)
	{

		char speed[5];

		if (!is_remove || (plot_node->is_drawn || plot_node->is_dead)) {		// if false then the point has not been plot yet, no need to remove

			float xorig, yorig;

			if (is_remove) {
				xorig = plot_node->x_pre;
				yorig = plot_node->y_pre;
				screen_writer->set_color(0x000000FF);
				plot_node->is_drawn = false;
			} else {
				xorig = plot_node->x;
				yorig = plot_node->y;
				screen_writer->set_color(plot_node->color_r, plot_node->color_g, plot_node->color_b, plot_node->color_a);
				plot_node->is_drawn = true;
			}

			int x = (int)(x0+xorig);
			int y = (int)(y0-yorig);
			int x_line = (int)(x0 + (xorig+plot_node->dx*(float)speed_line_ratio));
			int y_line = (int)(y0 - (yorig +plot_node->dy*(float)speed_line_ratio));
			int x_info = x+info_panel_length_s;
			int y_info = y-info_panel_length_s;

			sprintf(speed, "%d", (int)(plot_node->speed*200));

			//screen_writer->set_pixel(current_frame, x0+(plot_node->x>>amp_ratio_bits), y0+(plot_node->y>>amp_ratio_bits));
			screen_writer->draw_rectangular_align(current_frame, x-enemy_size, y-enemy_size, x-enemy_size, y+enemy_size, 2*enemy_size);
			screen_writer->draw_line(current_frame, x+enemy_size*sign_of_num(plot_node->dx), y+enemy_size*sign_of_num(plot_node->dy), x_line, y_line);
			screen_writer->draw_line(current_frame, x-enemy_size*sign_of_num(plot_node->dx), y-enemy_size*sign_of_num(plot_node->dy), x_line, y_line);

			screen_writer->draw_line(current_frame, x, y, x_info, y_info);
			screen_writer->draw_line(current_frame, x_info, y_info, x_info+info_panel_length_h, y_info);

			screen_writer->draw_text(current_frame, "[SPD]     KM/H ", x_info, y_info-8, 5);
			screen_writer->draw_text(current_frame, speed, x_info+28, y_info-10, 7);

			screen_writer->draw_text(current_frame, "[TYP] ", x_info, y_info+2, 5);
			if (plot_node->speed>(2*max_speed/3)) {
				screen_writer->draw_text(current_frame, "Tank-PzIII", x_info+28, y_info+2, 5);
			} else if (plot_node->speed>(max_speed/3)) {
				screen_writer->draw_text(current_frame, "PzVI-TIGER", x_info+28, y_info+2, 5);
			} else {
				screen_writer->draw_text(current_frame, "PzVIII-Maus", x_info+28, y_info+2, 5);
			}

		}
	}


	int get_enemy_num()
	{
		return enemy_num;
	}

	int sign_of_num(float num)
	{
		return (num>=0)?1:-1;
	}


};



#endif //__ENEMY_SYS_HPP_
