# Configuration file for jupyter nbconvert
c = get_config()
c.Exporter.preprocessors = ['pre_pymarkdown.PyMarkdownPreprocessor']
