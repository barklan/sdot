local M = {}

M.list_block = {
    "lock",
    "exe",
    "msi",
    "db",
    "iso",
    "bin",
    "DS_Store",
}

M.list_nontext = {
    -- Images
    "jpg",
    "jpeg",
    "png",
    "tif",
    "bmp",
    "gif",
    "svg",
    "ico",
    "webp",
    -- Video
    "mp4",
    "mkv",
    "mov",
    "avi",
    "flv",
    "ts",
    -- Audio
    "flac",
    "mp3",
    "ogg",
    "wav",
    "aac",
    -- Archives
    "gz",
    "tar",
    "zip",
    "rar",
    "7z",
    -- Documents
    "pdf",
    "djvu",
    "epub",
    "fb2",
    "odt",
    "doc",
    "docx",
    "rtf",
    "xls",
    "xlsx",
    "ppt",
    "pptx",
}

M.list_text = {
    -- Common text
    "txt",
    "md",
    "LICENSE",
    "tex",
    -- Shell
    "sh",
    "fish",
    "bash",
    -- Languages
    "go",
    "py",
    "lua",
    "mod",
    "php",
    "vim",
    "rs",
    "pas",
    "js",
    "ts",
    "tsx",
    "vue",
    "java",
    "sc",
    "cs",
    "c",
    "h",
    "cpp",
    "scala",
    "rb",
    "asm",
    -- Datatypes and configs
    "cfg",
    "log",
    "dockerignore",
    "pac",
    "bashrc",
    "gitconfig",
    "ini",
    "sql",
    "service",
    "timer",
    "dockerfile",
    "Dockerfile",
    "html",
    "css",
    "xml",
    "justfile",
    "Makefile",
    "env",
    "gitignore",
    "yaml",
    "yml",
    "toml",
    "json",
    "csv",
    "conf",
    "glsl",
}

return M
