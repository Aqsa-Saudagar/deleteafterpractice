variable "amiid" {
    default =  "ami-09d88f7c4c272b0c5"
}

variable "insttype" {
    default = "t3.micro"
}

variable "sg" {
   default = "sg-0d06a29eacde65701" 
}

variable "kp" {
    default = "linuxkey"

}


variable "instno" {
    default = 2
}

variable "apiterm" {
    default = false
}