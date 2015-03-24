username = "sigurdpl"
job("${username}.roadshow.generated.build") {
    scm {
        git("git@github.com:${username}/roadshow.git", "master")
    }
    triggers {
        scm('* * * * *')
    }
    steps {
        gradle('clean war jenkinstest jacoco')
      	shell('echo hello girl')
    }
  	publishers {
      	jacocoCodeCoverage()
      	archiveJunit('build/test-results/*.xml')
      	warnings(['Java Compiler (javac)'])
    	downstream("${username}.roadshow.generated.staticanalysis", 'SUCCESS')
    }
}

job("${username}.roadshow.generated.staticanalysis") {
    scm {
        git("git@github.com:${username}/roadshow.git", "master")
    }
    steps {
        gradle('clean staticanalysis')
    }
  	publishers {
      checkstyle('build/reports/checkstyle/*.xml')	
      pmd('build/reports/pmd/*.xml')
      tasks('**/*', '', 'FIXME', 'TODO', 'LOW', true)
  	}
}
