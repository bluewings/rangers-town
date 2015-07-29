'use strict'

images = [

  '371885 - big bigblind blind casino chip chips poker.png'
  '371886 - card casino cover green poker.png'
  '371887 - card casino k king poker spades.png'
  '371888 - card casino poker spades.png'
  '371889 - card casino poker spades.png'
  '371890 - card casino poker spades.png'
  '371891 - card casino hearts j jack poker.png'
  '371892 - card casino hearts poker.png'
  '371893 - card casino hearts poker.png'
  '371894 - card casino deck diamonds poker q queen red.png'
  '371895 - card casino deck diamonds j jack poker red.png'
  '371896 - card casino deck diamonds poker red.png'
  '371897 - card casino deck diamonds poker red.png'
  '371898 - card casino deck diamonds poker red.png'
  '371899 - card casino clubs deck poker q queen.png'
  '371900 - a ace aces card casino clubs deck poker.png'
  '371901 - card casino clubs deck poker.png'
  '371902 - card casino clubs deck poker.png'
  '371903 - blind casino chips playing poker small smallblind.png'
  '371904 - casino chips green playing poker.png'
  '371905 - chips dealer orange playing poker.png'
  '371906 - casino chips poker.png'
  '371907 - blue casino chips playing poker.png'
  '371908 - casino chips orange playing poker.png'
  '371909 - casino chips playing poker red.png'
  '371910 - card casino clubs deck poker.png'
  '371911 - card casino clubs deck poker.png'
  '371912 - card casino clubs deck poker.png'
  '371913 - card casino clubs deck poker.png'
  '371914 - card casino clubs deck poker.png'
  '371915 - card casino clubs deck poker.png'
  '371916 - card casino clubs deck poker.png'
  '371917 - card casino clubs deck j jack poker.png'
  '371918 - card casino clubs deck k king poker.png'
  '371919 - card casino deck diamonds poker red.png'
  '371920 - card casino deck diamonds poker red.png'
  '371921 - card casino deck diamonds poker red.png'
  '371922 - card casino deck diamonds poker red.png'
  '371923 - card casino deck diamonds poker red.png'
  '371924 - card casino deck diamonds poker red.png'
  '371925 - a ace aces card casino deck diamonds poker red.png'
  '371926 - card casino deck diamonds k king poker red.png'
  '371927 - card casino deck hearts poker.png'
  '371928 - card casino hearts poker.png'
  '371929 - card casino hearts poker.png'
  '371930 - card casino hearts poker.png'
  '371931 - card casino hearts poker.png'
  '371932 - card casino hearts poker.png'
  '371933 - card casino hearts poker.png'
  '371934 - a ace aces card casino hearts poker.png'
  '371935 - card casino hearts k king poker.png'
  '371936 - card casino hearts poker q queen.png'
  '371937 - card casino poker spades.png'
  '371938 - card casino poker spades.png'
  '371939 - card casino poker spades.png'
  '371940 - card casino poker spades.png'
  '371941 - card casino poker spades.png'
  '371942 - card casino poker spades.png'
  '371943 - a ace aces card casino poker spades.png'
  '371944 - card casino j jack poker spades.png'
  '371945 - card casino poker q queen spades.png'
  '371946 - card casino cover poker.png'
  '371947 - blue card casino cover poker.png'
  '371948 - card casino cover orange poker.png'
  '371949 - card casino cover poker red.png'

]

newImages = [
  "371937 - card casino poker spades.png",
  "371890 - card casino poker spades.png",
  "371938 - card casino poker spades.png",
  "371939 - card casino poker spades.png",
  "371940 - card casino poker spades.png",
  "371889 - card casino poker spades.png",
  "371941 - card casino poker spades.png",
  "371942 - card casino poker spades.png",
  "371888 - card casino poker spades.png",
  "371944 - card casino j jack poker spades.png",
  "371945 - card casino poker q queen spades.png",
  "371887 - card casino k king poker spades.png",
  "371943 - a ace aces card casino poker spades.png",
  "371927 - card casino deck hearts poker.png",
  "371928 - card casino hearts poker.png",
  "371929 - card casino hearts poker.png",
  "371930 - card casino hearts poker.png",
  "371893 - card casino hearts poker.png",
  "371931 - card casino hearts poker.png",
  "371932 - card casino hearts poker.png",
  "371933 - card casino hearts poker.png",
  "371892 - card casino hearts poker.png",
  "371891 - card casino hearts j jack poker.png",
  "371936 - card casino hearts poker q queen.png",
  "371935 - card casino hearts k king poker.png",
  "371934 - a ace aces card casino hearts poker.png",
  "371910 - card casino clubs deck poker.png",
  "371911 - card casino clubs deck poker.png",
  "371912 - card casino clubs deck poker.png",
  "371902 - card casino clubs deck poker.png",
  "371913 - card casino clubs deck poker.png",
  "371914 - card casino clubs deck poker.png",
  "371901 - card casino clubs deck poker.png",
  "371915 - card casino clubs deck poker.png",
  "371916 - card casino clubs deck poker.png",
  "371917 - card casino clubs deck j jack poker.png",
  "371899 - card casino clubs deck poker q queen.png",
  "371918 - card casino clubs deck k king poker.png",
  "371900 - a ace aces card casino clubs deck poker.png",
  "371919 - card casino deck diamonds poker red.png",
  "371920 - card casino deck diamonds poker red.png",
  "371898 - card casino deck diamonds poker red.png",
  "371921 - card casino deck diamonds poker red.png",
  "371922 - card casino deck diamonds poker red.png",
  "371897 - card casino deck diamonds poker red.png",
  "371923 - card casino deck diamonds poker red.png",
  "371924 - card casino deck diamonds poker red.png",
  "371896 - card casino deck diamonds poker red.png",
  "371895 - card casino deck diamonds j jack poker red.png",
  "371894 - card casino deck diamonds poker q queen red.png",
  "371926 - card casino deck diamonds k king poker red.png",
  "371925 - a ace aces card casino deck diamonds poker red.png",
  "371946 - card casino cover poker.png",
  "371949 - card casino cover poker red.png",
  "371948 - card casino cover orange poker.png",
  "371886 - card casino cover green poker.png",
  "371947 - blue card casino cover poker.png"
]
angular.module 'rangers'
.controller 'ProfileController', ($scope, $element, user, rangers, stages) ->  
  vm = @

  vm.user = user
  vm.rangers = rangers

  vm.images = images
  vm.newImages = newImages

  vm.addImage = (img) ->
    vm.newImages.push img

  vm.removeImage = (img) ->

    vm.newImages.splice(vm.newImages.indexOf(img), 1)
  # vm.ranger = rangers[Math.floor(Math.random() * rangers.length)]

  vm.update = ->
    vm.user.$update()
    return

  resizeImage = (img, rate) ->
    #/ step 1
    oc = document.createElement('canvas')
    octx = oc.getContext('2d')
    oc.width = img.width * rate
    oc.height = img.height * rate
    console.log img.width, img.height
    console.log oc.width, oc.height
    octx.drawImage img, 0, 0, oc.width, oc.height
    #/ step 2
    # octx.drawImage oc, 0, 0, oc.width * rate, oc.height * rate
    return oc
    # canvas.width = 400
    # canvas.height = 150
    # ctx.drawImage oc, 0, 0, oc.width * rate, oc.height * rate, 0, 0, canvas.width, canvas.height


  canvas = $element.find('canvas')[0]
  ctx = canvas.getContext '2d'


  w = 190
  h = 256

  _w = 114
  _h = 154


  canvas.width = _w * 13
  canvas.height = _h * 5
  tCanvas = document.createElement 'canvas'
  tCanvas.width = w
  tCanvas.height = h
  tCtx = tCanvas.getContext '2d'


  setTimeout ->
    j = 0
    k = 13

    $($element).find('img').each (index, img) ->
      # tCtx.fillStyle = 'blue'
      tCtx.clearRect(0,0,w,h)

      console.log img
      console.log img.width, img.height

      tCtx.drawImage img, (256 - w) / 2, (256 - h) / 2, w, h, 0, 0, w, h
      if index isnt 0 and index % k is 0
        j++
      # ctx.drawImage tCanvas, (index % k) * (w), j * h

      resized = resizeImage tCanvas, 0.6
      console.log resized
      # ctx.drawImage resized, (256 - w) / 2, (256 - h) / 2, w, h, (index % k) * (w), j * h, w, h
      ctx.drawImage resized, _w * (index % k), _h * j

      # console.log img

  , 2000

    
  return