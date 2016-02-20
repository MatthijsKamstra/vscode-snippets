package ;


import sys.io.File;
import sys.io.FileOutput;
import sys.FileSystem;

using StringTools;

/**
 * @author Matthijs Kamstra  aka [mck]
 * MIT
 * http://www.matthijskamstra.nl
 */
class Main
{
    private var path        = 'bin/Snippets';
    private var path_mck    = 'bin/mck-Snippets';
    private var out         = 'bin/new-Snippets'; 
    private var out_mck     = 'bin/new-mck-Snippets'; 
    private var vscode      = 'bin/vscode'; 

	public function new()
	{
        if(!FileSystem.exists(path)) FileSystem.createDirectory(path);
        if(!FileSystem.exists(path_mck)) FileSystem.createDirectory(path_mck);
        if(!FileSystem.exists(out)) FileSystem.createDirectory(out);
        if(!FileSystem.exists(out_mck)) FileSystem.createDirectory(out_mck);
        if(!FileSystem.exists(vscode)) FileSystem.createDirectory(vscode);
        
        convertOriginal(path);
        // convertOriginal(path_mck,'mck_');
        
        
    }
    
    private function convertOriginal(_path:String,?pfix:String='')
    {
        if(sys.FileSystem.exists(_path))
		{
            var haxejson = '\n\n/* \nThis is a converted list of haxe-sublime-bundle snippets created by Clément Charmet.\nhttps://github.com/clemos/haxe-sublime-bundle/tree/master/Snippets\n*/\n\n\n';
            var readme = '| shortcut | description |\n| --- | --- |\n';
            
            var list :Array<String> = FileSystem.readDirectory(_path);
            for (i in 0...list.length)
            {
                var _filename = list[i].split('.')[0];

                var xml : Xml = Xml.parse(File.getContent(_path + '/' + list[i]));
                
                var fast = new haxe.xml.Fast(xml.firstElement());
                var content = fast.node.content;
                var tabTrigger = fast.node.tabTrigger;
                var description = fast.node.description;
                
                readme += '| ${tabTrigger.innerData} | ${description.innerData} |\n';

                // trace(tabTrigger.innerData); 
                // trace(description.innerData);
                
                var _content = content.innerData
                                .replace(":$TM_SELECTED_TEXT",":// your code")
                                .replace("${3::${4:Void}}", ":${4:Void}") // [mck] hack private function
                                .replace("${5:$HX_W_OCB", "")
                                .replace("$HX_W_OCB"," ")
                                .replace("$HX_K_W_ORB"," ")
                                .replace("$HX_ORB_W"," ")
                                .replace("$HX_W_CRB"," ")
                                .replace("$HX_W_OCB"," ")
                                .replace("$HX_W_ORB"," ")
                                .replace("$HX_W_C"," ")
                                .replace("$HX_W_TD"," ")
                                .replace("$HX_TD_W", " ")
                                .replace("$HX_C_W"," ")
                                .replace("$HX_W_A"," ")
                                .replace("${HX_A_W}" , " ")
                                .replace("$HX_A_W", " ")
                                .replace("${HX_CCB_W}", " ")
                                .replace("\\}}", "}")
                           
                                .replace("}}", "}")
                        
                                .replace("${2:${3", "${3")
                                .replace("\\}", "")
                                .replace(":$TM_SELECTED_TEXT}$0","}")
                                ;
                                
                var contentArr : Array<String> = _content.split("\n");
                var __cont = '';
                for (i in 0...contentArr.length){
                    __cont += '"' + contentArr[i] + '" ,';
                }
                // [mck] remove that pesky last comma
                __cont = __cont.substr(0,__cont.length-1);        

                var json  = '"$_filename" : {\n\t"prefix":"${tabTrigger.innerData}", \n\t"body":[${__cont}], \n\t"description":"${description.innerData}"\n}';
                
                haxejson += json;
                haxejson += ',\n\n';
                
                var _filePath = out + '/' + pfix + _filename + '.json';
                var f:FileOutput = File.write(_filePath,false);
                f.writeString('{\n' + json + '\n}');
                f.close();
                
            }
            
            var _filePath = vscode + '/' + pfix + 'haxe.json';
            var f:FileOutput = File.write(_filePath,false);
            f.writeString(haxejson.substr(0,haxejson.length-3));
            f.close();
            
            var _filePath = vscode + '/' + pfix + 'shortcuts.md';
            var f:FileOutput = File.write(_filePath,false);
            f.writeString(readme);
            f.close();
            
            
		}
	}

	
	
    static public function main()
    {
       var main = new Main();
	}
}

