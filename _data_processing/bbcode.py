import yaml
import re
import html
import urllib
from IPython.display import display, clear_output

class bbcode:
    
    def __init__(self, post_pagination_filepath = '', smiley_code_map_filepath = ''):

        self.post_pagination = None
        self.post_pagination_filepath = post_pagination_filepath

        with open(smiley_code_map_filepath, 'r') as f:
            self.smiley_code_map = yaml.load(f.read(), Loader=yaml.FullLoader)
    
    def replace_simple_tags(self, txt, bb_uid):
        tags = {
            'u' : 'U',
            'b' : 'STRONG',
            'i' : 'EM',
            's' : 'STRIKE',
            'sup' : 'SUP',
            'super' : 'SUP',
            'sub' : 'SUB',
            'code' : 'PRE',
            '*' : 'LI'
        }
        for t_before, t_after in  tags.items():

            start_tag_before = f'[{t_before}:{bb_uid}]'
            start_tag_after = f'<{t_after}>'
            end_tag_before = f'[/{t_before}:{bb_uid}]'
            end_tag_before_m = f'[/{t_before}:m:{bb_uid}]'
            end_tag_before_u = f'[/{t_before}:u:{bb_uid}]'
            end_tag_before_o = f'[/{t_before}:o:{bb_uid}]'
            end_tag_after = f'</{t_after}>'
            
            txt = txt \
                .replace(start_tag_before, start_tag_after) \
                .replace(end_tag_before, end_tag_after) \
                .replace(end_tag_before_m, end_tag_after) \
                .replace(end_tag_before_u, end_tag_after) \
                .replace(end_tag_before_o, end_tag_after)
                
        return txt

    def replace_linebreaks(self, txt, bb_uid):
        # first, remove excess line breaks after selected end-tags
        rep1 =  r'\1' + f'[br:{bb_uid}]'
        txt = re.sub(f'(\[\/(list|quote|code|\*)(\:(m|o|u))?\:{bb_uid}\])\n', rep1, txt)
        # ... and after selected start tags
        txt = re.sub(f'(\[(list|quote|code|\*)(=[^\:]+)?\:{bb_uid}\])\n', rep1, txt)
        # then, change all other lien breaks to BRs
        txt = re.sub('(?<!\n)\n(?!\n)', '<BR />\n', txt)
        txt = re.sub('(?<!\n)\n\n+(?!\n)', '<BR />\n<BR />\n', txt)
        # then restore the linebreaks after selected tags for readability
        txt = re.sub(f'\[br\:{bb_uid}]', '\n', txt)
        return txt

    def replace_quotes(self, txt, bb_uid):

        txt = re.sub(
            f'\[quote\=(?:\&quot\;)([^\&]+)(?:\&quot\;):{bb_uid}\]',
            r'<BLOCKQUOTE><P>\n»\1« pisze:<BR />\n',
            txt
        )

        txt = re.sub(
            f'\[quote\:{bb_uid}\]',
            r'<BLOCKQUOTE><P>\ncytat:<BR />\n',
            txt
        )

        txt = re.sub(
            f'\[\/quote(\:(o|u|m))?\:{bb_uid}\]',
            '\n</P></BLOCKQUOTE>',
            txt
        )

        return txt
    
    def replace_lists(self, txt, bb_uid):

        txt = re.sub(
            f'\[list\=(.)\:{bb_uid}\]',
            r'<OL type="\1">',
            txt
        )
        txt = re.sub(
            f'\[list\:{bb_uid}\]',
            r'<UL>',
            txt
        )
        txt = re.sub(
            f'\[\/list\:o\:{bb_uid}\]',
            r'</OL>',
            txt
        )
        txt = re.sub(
            f'\[\/list\:u\:{bb_uid}\]',
            r'</UL>',
            txt
        )

        return txt

    def load_post_pagination(self):
        
        with open(self.post_pagination_filepath , 'r') as f:
            self.post_pagination = yaml.load(f.read(), Loader=yaml.FullLoader)
    
    def translate_url(self, url):

        if self.post_pagination == None:
            self.load_post_pagination()
        
        new_url = url

        known_hosts = [
            'http://pwgay.org/forum/',
            'http://pwgay.7z9.net/forum/'
            'http://pwgy.vipserv.org/'
        ]
        m = 0
        for host_pattern in known_hosts:
            m += len(re.findall(host_pattern, url))

        if m >0 :

            param_pattern = '[a-zA-Z]+\=[0-9a-zA-Z]+'
            params = re.search(
                f'(?:viewtopic|vievforum).php\?((?:{param_pattern})(?:\&{param_pattern})*)',
                url
            )
            
            if params != None:

                param_arr = params.group(1).split('&')
                param_dict = { p.split('=')[0] : p.split('=')[1] for p in param_arr}

                post_id = param_dict.get('p')
                topic_id = param_dict.get('t')
                forum_id = param_dict.get('f')
                
                if post_id != None:

                    link_params = post_pagination.get(int(post_id))

                    if link_params != None:
                    
                        thread_num = link_params['t']
                        page_num = link_params['p']
                        if page_num == 1:
                            new_url = f'/thread/{thread_num}/index.html#post_{post_id}'
                        else:
                            new_url = f'/thread/{thread_num}/page_{page_num}.html#post_{post_id}'
                    
                    else:

                        encoded_old_url = urllib.parse.quote(url)
                        new_url = f'/missing_post.html?link={encoded_old_url}'

                elif topic_id != None:

                    new_url = f'/threads/{topic_id}/index.html'

                elif forum_id != None:

                    new_url = f'/forums/{forum_id}/index.html'
        
        return new_url

    def url_tag(self, url, make_tag='none', translate_url=True):

        url = html.unescape(url)

        if translate_url == True:
            url = self.translate_url(url)

        if make_tag == 'full':
            url = f'<A href="{url}">{url}</A>'
        if make_tag == 'start':
            url = f'<A href="{url}">'

        return url

    def replace_url(self, txt, bb_uid, translate_url):
    
        # simple URL
        txt = re.split(
        f'\[url\:{bb_uid}\]([^\[]+)\[\/url\:{bb_uid}\]',
        txt
        )
        txt = [ item if index%2 == 0 else self.url_tag(item, make_tag='full', translate_url=translate_url) for index, item in enumerate(txt)]
        txt = ''.join(txt)

        # complex URL
        open_tag = f'\[url\=([^\:]+)\:{bb_uid}\]'
        close_tag = f'\[\/url\:{bb_uid}\]'
        txt = re.split(
            open_tag,
            txt
        )
        txt = [ item if index%2 == 0 else self.url_tag(item, make_tag='start', translate_url=translate_url) for index, item in enumerate(txt)]
        txt = ''.join(txt)
        txt = re.sub(
            close_tag,
            '</A>',
            txt
        )

        return txt

    def replace_size(self, txt, bb_uid):
        pattern_start = f'\[size=([0-9]+)\:{bb_uid}]'
        pattern_end = f'\[\/size\:{bb_uid}]'
        txt = re.sub(
            pattern_start,
            r'<SPAN style="font-size:\1%">',
            txt
        )
        txt = re.sub(
            pattern_end,
            r'</SPAN>',
            txt
        )
        return txt

    def repalce_color(self, txt, bb_uid):
        pattern_start = f'\[color=([\#a-zA-Z0-9]+)\:{bb_uid}\]'
        pattern_end = f'\[\/color\:{bb_uid}]'
        txt = re.sub(
            pattern_start,
            r'<SPAN style="color:\1">',
            txt
        )
        txt = re.sub(
            pattern_end,
            r'</SPAN>',
            txt
        )
        return txt

    def img_tag(self, url):

        url = html.unescape(url)
        search_url = f'https://web.archive.org/web/20240000000000*/{url}'
        search_url_safe = html.escape(search_url)
        url_display = url
        if len(url) >50:
            url_display = f'{url[:20]} ... {url[-20:]}'
        url_display = html.escape(url_display)
        tag =f'''<P class="image_holder">
        <IMG src="{url}" /><br />
        <A href="{search_url_safe}" title="poszukaj w internet archive">{url_display}</A>
        </P>'''
        return tag

    def replace_img(self, txt, bb_uid):
   
        txt = re.split(
        f'\[img\:{bb_uid}\]([^\[]+)\[\/img\:{bb_uid}\]',
        txt
        )
        txt = [ item if index%2 == 0 else self.img_tag(item) for index, item in enumerate(txt)]
        txt = ''.join(txt)

        return txt

    def replace_attachment(self, txt, post_id, bb_uid):

        pattern_start= f'\[attachment=([0-9]+)\:{bb_uid}\]'
        pattern_end = f'\[\/attachment\:{bb_uid}\]'
        txt = re.sub(
            pattern_start,
            f'<A {{% include inline_attachment.html post_id={post_id} ' + r'attachment_index=\1' + ' %} />',
            txt
        )
        txt = re.sub(
            pattern_end,
            '</A>',
            txt
        )
        return txt

    def map_smiely_code(self, code):

        smiley_id = self.smiley_code_map.get(code)
        smiley_txt = f'{{% include smiley.html smiely_id={smiley_id} %}}'
        
        return smiley_txt

    def replace_smilies(self, txt):

        pattern = r'\<\!\-\- s([^\ ]+) \-\-\>\<img +src\=\"\{SMILIES\_PATH\}\/[^\"]+\"(?: +alt\=\"[^\"]+\")?(?: +title\=\"[^"]+\")? \/\>\<\!\-\- s[^ ]+ \-\-\>'
        txt = re.split(
            pattern,
            txt
        )
        txt = [value if index%2 == 0 else  self.map_smiely_code(value) for index, value in enumerate(txt)]

        return ''.join(txt)

    def tex_tag(self, txt):

        tex = html.unescape(txt)
        url = urllib.parse.quote(tex)
        tex = tex.replace('\n', '')
        tex = re.sub(' +', ' ', tex)
        tag = '<DIV class="tex">' + \
            f'<IMG src="https://latex.codecogs.com/gif.latex?{url}" alt="{tex}" title="{tex}"/>' + \
            f'<div><CODE>{tex}</CODE></div>' + \
            '</div>'

        return tag

    def replace_tex(self, txt, bb_uid):
    
        txt = re.split(
        f'(\[tex\:{bb_uid}\]|\[\/tex\:{bb_uid}\])\n*',
        txt
        )
        
        txt = [value if index% 4 == 0 else self.tex_tag(value) for index, value in enumerate(txt) if index%2 == 0]
        txt = ''.join(txt)

        return txt

    def yt_tag(self, txt):

        tag = f'<iframe width="560" height="315" src="https://www.youtube.com/embed/{txt}"></iframe>'
        tag= '<DIV class="youtube_embed">' + \
            f'<iframe  width="560" height="315" src="https://www.youtube.com/embed/{txt}"></iframe>' + \
            f'<div><A href="https://www.youtube.com/watch?v={txt}" title="zobacz na YouTube">' + \
            f'https://www.youtube.com/watch?v={txt}' + \
            '</A></div></DIV>'
        return tag

    def replace_youtube(self, txt, bb_uid):

        txt = re.split(
        f'(\[youtube\:{bb_uid}\]|\[\/youtube\:{bb_uid}\])\n*',
        txt
        )
        
        txt = [value if index% 4 == 0 else self.yt_tag(value) for index, value in enumerate(txt) if index%2 == 0]
        txt = ''.join(txt)

        return txt

    def parese_post_bb_code(self, text, post_id, bb_uid, translate_url = True):
        final_text = self.replace_tex(text, bb_uid)
        final_text = self.replace_linebreaks(final_text, bb_uid)
        final_text = self.replace_simple_tags(final_text, bb_uid)
        final_text = self.replace_quotes(final_text, bb_uid)
        final_text = self.replace_lists(final_text, bb_uid)
        final_text = self.replace_url(final_text, bb_uid, translate_url)
        final_text = self.replace_size(final_text, bb_uid)
        final_text = self.repalce_color(final_text, bb_uid)
        final_text = self.replace_img(final_text, bb_uid)
        final_text = self.replace_attachment(final_text, post_id, bb_uid)
        final_text = self.replace_smilies(final_text)
        final_text = self.replace_youtube(final_text, bb_uid)
        return final_text
    