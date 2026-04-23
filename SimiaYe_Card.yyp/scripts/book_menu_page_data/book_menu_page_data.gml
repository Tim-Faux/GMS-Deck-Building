#macro BOOK_PAGE_ELEMENT_PADDING 20

/// @desc							A struct used for obj_page to manage the elements on the page
/// @param {Real} page_x			The x position of the page's left side
/// @param {Real} page_y			The y position of the page's top edge
/// @param {Real} page_height		The size of the page vertically
/// @param {Real} page_width		The size of the page horizontally
function book_menu_page_data(page_x, page_y, page_height, page_width) constructor {
		min_x = page_x
		min_y = page_y
		first_column_x_pos = page_x + BOOK_PAGE_ELEMENT_PADDING
		next_element_y_pos = page_y + BOOK_PAGE_ELEMENT_PADDING
		page_max_height = page_y + page_height
		page_max_width = page_width
		all_pages = [{elements: {}}]
		
		/// @desc							Adds a header line at the top of the page. NOTE: There can
		///										only be a single header per page
		/// @param {String} header_text		The text to be shown in the header
		static add_header = function(header_text) {
			all_pages[array_length(all_pages) - 1].elements[$ "header"] = 
			{
				x_pos : min_x + (page_max_width / 2),
				y_pos : min_y + BOOK_PAGE_ELEMENT_PADDING,
				text : header_text,
				font : fnt_book_menu_header,
				text_alignment : fa_center
			}
			draw_set_font(fnt_book_menu_header)
			next_element_y_pos += string_height(header_text) + (2 * BOOK_PAGE_ELEMENT_PADDING)
		}
		
		/// @desc										Adds elements to the page that the player can interact
		///													with, creating a new page if the element is
		///													larger than the space on the page. NOTE: These
		///													need to be added in order and after the header
		///													to appear properly on the page
		/// @param {string} element_name				The string used to identify the element in the
		///													page's elements struct
		/// @param {Asset.GMObject} selection_element	The element the player can interact with
		/// @param {string} text						The string to be shown next to the selection_element
		static add_element = function(element_name, selection_element, text) {
			if(array_length(all_pages) <= 0) {
				all_pages = [{elements: {}}]
			}
			
			var element_height = sprite_get_height(object_get_sprite(selection_element)) + BOOK_PAGE_ELEMENT_PADDING
			if(next_element_y_pos + element_height > page_max_height) {
				all_pages[array_length(all_pages)] = {elements: {}}
				next_element_y_pos = min_y + BOOK_PAGE_ELEMENT_PADDING
			}
			
			all_pages[array_length(all_pages) - 1].elements[$ element_name] = 
			{
				x_pos : first_column_x_pos,
				y_pos : next_element_y_pos + sprite_get_yoffset(object_get_sprite(selection_element)),
				element : selection_element,
				text,
				font : fnt_book_menu_elements,
				text_alignment : fa_left
			}
			
			next_element_y_pos += element_height
		}
}